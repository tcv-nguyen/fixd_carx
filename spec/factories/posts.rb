FactoryBot.define do
  factory :post do
    user
    title     { Faker::Book.title }
    body      { Faker::Lorem.paragraphs(number: 10).join }
    posted_at { Time.current }
  end
end
