class Rating < ApplicationRecord
  belongs_to :answer
  belongs_to :user

  validates :rating, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :answer_id }
end
