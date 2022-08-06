class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :rater, foreign_key: :rater_id, class_name: 'User'

  validates :rating, presence: true, inclusion: { in: (1..5), 
    message: 'must be between 1 and 5' }
  # Should be added at database level but there are duplicate records
  # Migration couldn't run through until Rating table is clear of duplicate
  validates :user_id, uniqueness: { scope: :rater_id }

  before_create :generate_rated_at
  after_create :recalculate_user_rating

  private
    def generate_rated_at
      self.rated_at ||= Time.current
    end

    def recalculate_user_rating
      user.calculate_rating!
    end
end
