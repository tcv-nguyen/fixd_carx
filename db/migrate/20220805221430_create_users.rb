class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, :name, :github_username, :registered_at

      t.timestamps
    end
  end
end
