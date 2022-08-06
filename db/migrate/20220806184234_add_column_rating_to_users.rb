class AddColumnRatingToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :rating, :decimal, default: 0, precision: 10, scale: 1
    add_column :users, :high_rating, :boolean, default: false
  end
end
