FactoryBot.define do
  factory :github_event do
    user
    event_id  { Time.current.to_i.to_s }
    repo_name { 'facebook/react' }
    event_created_at  { Time.current }

    trait :new_repo do
      event_name  { 'new_repo' }
    end

    trait :new_pr do
      event_name  { 'new_pr::#5' }
    end

    trait :merged do
      event_name  { 'merged_pr::#5' }
    end

    trait :commit do
      event_name  { 'commit::This is a commit message' }
    end
  end
end
