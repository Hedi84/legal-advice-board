FactoryBot.define do
  factory :rating do
    association :answer
    association :user
    rating { rand(1..5) }
    rated_at { Time.current }
  end
end
