FactoryBot.define do
  factory :comment do
    user
    post
    message      { Faker::Lorem.paragraphs(number: 5).join }
    commented_at { Time.current }
  end
end
