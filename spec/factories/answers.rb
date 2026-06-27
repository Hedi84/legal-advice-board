FactoryBot.define do
  factory :answer do
    association :question
    association :lawyer, factory: :user, role: :lawyer
    response { "Based on the details you have provided, you are entitled to at least 2 months notice in writing." }
    proposed_fee_pounds { 50.00 }
  end
end
