class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :message, presence: true

  before_create :generate_commented_at
  after_create :add_event

  private
    def generate_commented_at
      self.commented_at ||= Time.current
    end

    def add_event
      author = post.user
      Event.create(
        user_id: self.user_id,
        eventable_type: 'Comment',
        eventable_id: self.id,
        event_time_at: self.commented_at,
        title: author.name,
        description: author.rating
      )
    end
end
