class AddColumnHighRatingAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :high_rating_at, :datetime
  end
end
