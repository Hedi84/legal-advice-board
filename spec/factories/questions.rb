FactoryBot.define do
  factory :question do
    association :user
    title { "Can my landlord do this?" }
    body { "My landlord has told me I need to leave within 7 days without any written notice." }
    category { "Housing" }
    status { :open }
  end
end
