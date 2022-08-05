class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :rater, foreign_key: :rater_id, class_name: 'User'
end
