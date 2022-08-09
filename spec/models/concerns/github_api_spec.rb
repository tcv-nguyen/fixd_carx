require 'rails_helper'

RSpec.describe GithubApi do
  let(:user) { create(:user, github_username: 'torvalds') }
  let(:github_api) { GithubApi.new }
  # user_id, event_id, repo_name, event_created_at, event_name
  # user_id, eventable_type, eventable_id, title, event_time_at, description
  let(:columns) { %i(user_id eventable_type eventable_id title event_time_at description) }
  let(:arrays) do
    5.times.each_with_object([]) do |n, array|
      array.push([
        user.id,
        'GithubEvent',
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
      expect { github_api.save_events(arrays) }.to change { Event.count }.from(0).to(5)
    end

    it 'should not create record for event_id already exist' do
      old_record = arrays.first
      Event.create(columns.zip(old_record).to_h)

      expect { github_api.save_events(arrays) }.to change { Event.count }.from(1).to(5)
    end
  end

  describe '#fetch_user(user)' do
    let(:filename) { "github_api/#{user.github_username}" }

    it 'should create GithubEvent for User' do
      # For when you want you clear VCR and reload
      # clear_vcr(filename)

      expect(Event.count).to eq(0)

      VCR.use_cassette(filename) do
        github_api.fetch_user(user)
      end

      expect(Event.count).to_not eq(0)
    end
  end
end
