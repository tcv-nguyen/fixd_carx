class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string  :eventable_type, :eventable_id
      t.string  :title, :description
      t.datetime  :event_time_at
    end

    add_index :events, [:user_id, :eventable_id, :eventable_type], unique: true
  end
end
