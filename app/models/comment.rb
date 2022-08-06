class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :message, presence: true

  before_create :generate_commented_at

  private
    def generate_commented_at
      self.commented_at ||= Time.current
    end
end
