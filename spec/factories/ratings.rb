FactoryBot.define do
  factory :rating do
    user
    association :rater, factory: :user
    rating  { (1..5).sample }
    rated_at { Time.current }
  end
end
