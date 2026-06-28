class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :lawyer, class_name: "User"
  has_one :payment, dependent: :destroy
  has_one :rating, dependent: :destroy

  validates :response, presence: true
  validates :proposed_fee_pounds,
          numericality: { greater_than: 0 }
  validates :lawyer_id, uniqueness: { scope: :question_id, message: "has already answered this question" }
end
