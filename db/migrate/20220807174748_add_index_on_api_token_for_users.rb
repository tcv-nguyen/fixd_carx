class AddIndexOnApiTokenForUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :api_token
  end
end
