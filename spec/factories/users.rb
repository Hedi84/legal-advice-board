FactoryBot.define do
  factory :user do
    name { "Alice Smith" }
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password123" }
    role { :user }
  end
end
