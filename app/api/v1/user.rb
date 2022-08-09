class Api::V1::User < Grape::API
  namespace :user do
    get :timeline do
      current_user.fetch_github_events if current_user.github_username.present?
      # Default is 25 records per page, start with page 1
      # User#timeline will return and array of data_hash with format:
        # 'record_type', 'display_date', 'title', 'footer'
        # to display on front end
      # Return events columns: eventable_type, title, description, event_time_at
      # eventable_type: Post, Comment, Rating (when User pass 4 stars), and GithubEvent
      # Front end need to base on record_type to display 'title', 'footer' properly
      # description 'GithubEvent' -> 'title' is 'repo_name', 'description' will be
      # different for each type of event:
        # 'new_repo' : New repository
        # 'new_pr::#5' : Create new PR #5
        # 'merged_pr::#6' : Merge PR #6
        # 'commit::<message>' : new commit with <message>
      # current_user.timeline(params.slice(:records, :page).symbolize_keys)
      page = params[:page] || 0
      events = Event.where(user_id: current_user.id).order('event_time_at DESC')
        .limit(params[:records]).offset(page)
      present events, with: Api::V1::Entities::Event
    end

    post :rate do
      rating = Rating.new(params.slice(:rating, :user_id).merge(rater_id: current_user.id))
      if rating.save
        status 200
        { message: 'Rating created' }
      else
        error!({ message: rating.errors.full_messages.join('. ') }, 422)
      end
    end
  end
end
