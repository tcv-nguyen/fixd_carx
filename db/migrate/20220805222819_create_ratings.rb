class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.integer :user_id, :rater_id, :rating
      t.datetime :rated_at

      t.timestamps
    end
  end
end
