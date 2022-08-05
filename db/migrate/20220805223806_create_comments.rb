class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.integer :user_id, :post_id
      t.text :message
      t.datetime :commented_at

      t.timestamps
    end
  end
end
