class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :events, dependent: :destroy

  before_save :set_high_rating
  after_save :add_event, if: -> { high_rating }

  def api_token_expired?
    self.api_token_expired_at.blank? || self.api_token_expired_at < Time.current
  end

  def generate_api_token
    self.api_token = SecureRandom.uuid
    self.api_token_expired_at = 1.day.from_now
  end

  def calculate_rating!
    rates = ratings.pluck(:rating)
    self.rating = (rates.inject(:+) / rates.size.to_f).round(1)
    save!
  end

  # def timeline(options = {})
  #   # Create query to return records with UNION between
  #   # Post, Comment, User tables
  #   # UNION these columns: record_id, record_type, display_date, footer
  #   # record_type for json to recognize which record it is to display properly
  #   # footer will be display based on record_type as well
  #   # record_type are: 'post' for Post, 'comment' for Comment
  #     # 'rating' for high_rating achievement 
  #     # 'github' for Github's events
  #   # For 'comment' type, the title will be Comment's Post's author
  #   options = { records: 25, page: 1 } if options.blank?

  #   sql = <<-SQL
  #     SELECT DISTINCT(posts.id), 'post' AS record_type, 
  #         posts.posted_at AS created_date, 
  #         to_char(posts.posted_at, 'DD Mon YY') AS display_date, 
  #         posts.title AS title, COUNT(DISTINCT c.id)::TEXT AS footer
  #       FROM posts 
  #         LEFT JOIN comments AS c
  #           ON posts.id = c.post_id
  #       WHERE posts.user_id = #{self.id}
  #       GROUP BY posts.id, posts.posted_at, posts.title
  #     UNION 
  #       SELECT DISTINCT(comments.id), 'comment' AS record_type, 
  #         comments.commented_at AS created_date, 
  #         to_char(comments.commented_at, 'DD Mon YY') AS display_date, 
  #         u.name AS title, u.rating::TEXT AS footer
  #       FROM comments 
  #         LEFT JOIN posts AS p 
  #           ON comments.post_id = p.id 
  #         LEFT JOIN users AS u 
  #           ON p.user_id = u.id
  #       WHERE comments.user_id = #{self.id}
  #       GROUP BY comments.id, comments.commented_at, u.name, u.rating
  #     UNION 
  #       SELECT users.id, 'rating' AS record_type, 
  #         users.high_rating_at AS created_date, 
  #         to_char(users.high_rating_at, 'DD Mon YY') AS display_date, 
  #         'Passed 4 stars!' AS title, users.rating::TEXT AS footer 
  #       FROM users
  #       WHERE users.id = #{self.id} 
  #         AND high_rating = 't'
  #     UNION 
  #       SELECT ge.id, 'github_event' AS record_type, 
  #         ge.event_created_at AS created_date, 
  #         to_char(ge.event_created_at, 'DD Mon YY') AS display_date, 
  #         ge.event_name AS title, ge.repo_name AS footer
  #       FROM github_events AS ge
  #       WHERE ge.user_id = #{self.id}
  #     ORDER BY created_date DESC
  #     LIMIT #{options[:records]}
  #     OFFSET #{options[:page].to_i - 1}
  #   SQL

  #   result = ActiveRecord::Base.connection.execute(sql.squish).to_a
  #   return [] if result.blank?
  #   result.map { |hash| hash.slice('record_type', 'display_date', 'title', 'footer') }
  # end

  def fetch_github_events
    # TODO: Need to set timeout in case the request run too long
    # or research Github webhook to update events.
    return if github_username.blank?
    github_api = GithubApi.new
    github_api.fetch_user(self)
  end
  
  private
    def set_high_rating
      # Should not change high_rating status if already pass rating 4
      # or lower than 4
      return if self.high_rating? || self.rating < 4
      self.high_rating = true
      self.high_rating_at ||= Time.current
    end

    def add_event
      events.create(
        eventable_type: 'Rating',
        eventable_id: self.id,
        event_time_at: self.high_rating_at,
        title: 'Passed 4 stars!',
        description: self.rating
      )
    end
end
