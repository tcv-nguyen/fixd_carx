class DropTableGithubEvent < ActiveRecord::Migration[7.0]
  def up
    drop_table :github_events
  end

  def down
  end
end
