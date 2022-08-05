class ChangeColumnTypeRegisteredAtFromUsers < ActiveRecord::Migration[7.0]
  def up
    remove_column :users, :registered_at
    add_column :users, :registered_at, :datetime
  end

  def down
    change_column :users, :registered_at, :string
  end
end
