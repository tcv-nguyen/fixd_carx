class CreateGithubEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :github_events do |t|
      t.integer :user_id
      t.string  :event_id, :repo_name, :event_name
      t.datetime  :event_created_at
    end
  end
end
