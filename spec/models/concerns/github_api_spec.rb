require 'rails_helper'

RSpec.describe GithubApi do
  let(:user) { create(:user, github_username: 'torvalds') }
  let(:github_api) { GithubApi.new }
  # user_id, event_id, repo_name, event_created_at, event_name
  let(:columns) { %i(user_id event_id repo_name event_created_at event_name) }
  let(:arrays) do
    5.times.each_with_object([]) do |n, array|
      array.push([
        user.id,
        "event_id_#{n}",
        "repo_name_#{n}",
        Time.current - n.days,
        "event_name_#{n}"
      ])
    end
  end

  before do
    github_api.user = user
  end

  describe '#save_events(arrays)' do
    it 'should convert array and insert data correctly' do
      expect { github_api.save_events(arrays) }.to change { GithubEvent.count }.from(0).to(5)
    end

    it 'should not create record for event_id already exist' do
      old_record = arrays.first
      GithubEvent.create(columns.zip(old_record).to_h)

      expect { github_api.save_events(arrays) }.to change { GithubEvent.count }.from(1).to(5)
    end
  end

  describe '#fetch_user(user)' do
    it 'should create GithubEvent for User' do
      filename = "github_api/#{user.github_username}"
      clear_vcr(filename)
      response = 
        VCR.use_cassette(filename) do
          github_api.fetch_user(user)
        end
    end
  end
end
