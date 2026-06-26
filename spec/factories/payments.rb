FactoryBot.define do
  factory :payment do
    association :answer
    association :requester, factory: :user, role: :user
    status { :pending }
    approved_at { nil }
  end
end
