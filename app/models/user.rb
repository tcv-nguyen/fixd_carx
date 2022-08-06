class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :ratings

  def api_token_expired?
    self.api_token_expired_at.blank? || self.api_token_expired_at < Time.current
  end

  def generate_api_token
    self.api_token = SecureRandom.uuid
    self.api_token_expired_at = 1.day.from_now
  end
end
