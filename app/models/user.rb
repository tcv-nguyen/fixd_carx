class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :ratings

  before_save :set_high_rating

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
  
  private
    def set_high_rating
      return if self.high_rating? # Should not change high_rating status if already pass rating 4
      self.high_rating = self.rating >= 4
    end
end
