class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  before_create :generate_posted_at

  private
    def generate_posted_at
      self.posted_at ||= Time.current
    end
end
