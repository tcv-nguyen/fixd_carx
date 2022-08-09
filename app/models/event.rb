class Event < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:eventable_id, :eventable_type] }
end
