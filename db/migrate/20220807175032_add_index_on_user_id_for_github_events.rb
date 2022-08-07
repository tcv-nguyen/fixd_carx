class AddIndexOnUserIdForGithubEvents < ActiveRecord::Migration[7.0]
  def change
    add_index :github_events, :user_id
  end
end
