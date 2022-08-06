class AddColumnApiTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :api_token, :string
    add_column :users, :api_token_expired_at, :datetime
  end
end
