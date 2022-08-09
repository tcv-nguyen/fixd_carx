class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  before_create :generate_posted_at
  after_create :add_event

  private
    def generate_posted_at
      self.posted_at ||= Time.current
    end

    def add_event
      Event.create(
        user_id: self.user_id,
        eventable_type: 'Post',
        eventable_id: self.id,
        event_time_at: self.posted_at,
        title: self.title,
        description: ''
      )
    end
end
