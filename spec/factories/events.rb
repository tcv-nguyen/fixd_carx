FactoryBot.define do
  factory :event do
    user
    eventable_type  { 'GithubEvent' }
    eventable_id    { Time.current.to_f.to_s }
    title           { 'facebook/react' }
    event_time_at   { Time.current }

    trait :new_repo do
      description { 'new_repo' }
    end

    trait :new_pr do
      description { 'new_pr::#5' }
    end

    trait :merged do
      description { 'merged_pr::#5' }
    end

    trait :commit do
      description { 'commit::This is a commit message' }
    end
  end
end
