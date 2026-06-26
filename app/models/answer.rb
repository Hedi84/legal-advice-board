class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :lawyer, class_name: "User"
  # has_one :payment, dependent: :destroy

  validates :response, presence: true
  validates :fee_pounds, numericality: { only_integer: true, greater_than: 0 }
end
