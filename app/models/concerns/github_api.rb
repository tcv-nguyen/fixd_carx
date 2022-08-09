class GithubApi
  # Create PR => 'PullRequestEvent' + 'payload' => {'action' => 'opened', 'number' => 2}
  # Merge PR => 'PullRequestEvent' + 'payload' => {'action' => 'closed', 'number' => 2}
  # Create repo => 'CreateEvent' + 'payload' => 'ref_type' = 'repository'
  # Create branch => 'CreateEvent' + 'payload' => 'ref_type' = 'branch'
  # Commit => 'PushEvent' + 'payload' => 'commits' => ['message']
  EVENTS = %w(CreateEvent PushEvent PullRequestEvent)

  attr_accessor :user

  def fetch_user(user)
    @user = user
    url = "https://api.github.com/users/#{@user.github_username}/events"
    events = HTTParty.get(url)
    arrays = collect_events(events)
    save_events(arrays) if arrays.present?
  end

  def collect_events(events)
    events.each_with_object([]) do |event, array|
      event_type = event.dig('type')
      # Collect only new repository, new PR, merge PR and commit events
      next unless EVENTS.include?(event_type)
      # Data format: user_id, event_id, repo_name, event_created_at, event_name
      # repo_name => title, event_name => description
      # Data format: user_id, eventable_type, eventable_id, title, event_time_at, 
        # description
      data = [
        @user.id,
        'GithubEvent',
        event.fetch('id', nil),
        event.dig('repo', 'name'),
        DateTime.parse(event.fetch('created_at', Time.current.to_s)),
        send("#{event_type.underscore}_name", event) # Call according methods to return proper hash for record
      ]
      next unless data.compact.length == 6
      array.push(data)
    end
  end

  def save_events(arrays)
    # Loop through array to collect event IDs
    # Query GithubEvent with event IDs and pluck existing IDs to extract
      # event IDs that not exists in the table
    # generate SQL and save all data as once
      # For speed since this usually called from API endpoint
    # Array of data_array format:
    # Data format: user_id, eventable_type, eventable_id, title, event_time_at, 
      # description
    event_ids = arrays.map { |array| array[2] }
    existed_ids = @user.events.where(eventable_id: event_ids).pluck(:eventable_id)
    new_event_ids = event_ids - existed_ids
    new_data = arrays.select { |array| new_event_ids.include?(array[2]) } # array[2] = event_id
    # Re-format new_data into SQL values
    values = new_data.map do |array|
      "(#{array.map { |value| "'#{value}'" }.join(', ')})"
    end.join(', ')
    return if values.blank?
    sql = <<-SQL
      INSERT INTO 
        events (user_id, eventable_type, eventable_id, title, event_time_at, description)
      VALUES #{values}
    SQL

    ActiveRecord::Base.connection.execute(sql.squish)
    # results = ActiveRecord::Base.connection.execute(sql.squish)
    # binding.pry
  end

  private
    # Dynamic methods generate for EVENTS allowed
    # Format: #{EVENT.underscore}_name => return event_name for title purpose
    def create_event_name(event)
      ref_type = event.dig('payload', 'ref_type')
      return [] unless ref_type == 'repository' # Create new repository
      'new_repo'
    end

    def push_event_name(event)
      # TODO: Can't research deep into how to geet PR number for the Commit and Merge event
      # Use generic message instead: get the commits last message as title
      commits = event.dig('payload', 'commits')
      last_commit = commits.last
      "commit::#{last_commit.fetch('message', '').gsub("'", "''")}" # Convert single quote for SQL save
    end

    def pull_request_event_name(event)
      action = event.dig('payload', 'action')
      return [] unless %w(opened closed).include?(action) # Opened/Merged new PR
      pr_number = event.dig('payload', 'number')
      "#{action == 'opened' ? 'new' : 'merged'}_pr::##{pr_number}"
    end
end
