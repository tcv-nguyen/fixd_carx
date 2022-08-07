class AddIndexOnUserIdForRatings < ActiveRecord::Migration[7.0]
  def change
    add_index :ratings, :user_id
    add_index :ratings, :rater_id
  end
end
