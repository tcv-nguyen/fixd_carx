FactoryBot.define do
  factory :user do
    name  { Faker::Name.name }
    email { Faker::Internet.email }

    transient do
      with_api_token { false }
    end

    before(:create) do |user, evaluator|
      if evaluator.with_api_token
        user.generate_api_token
      end
    end
  end
end
