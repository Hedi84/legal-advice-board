class Question < ApplicationRecord
  CATEGORIES = [
    "Employment",
    "Housing",
    "Family",
    "Wills and Probate",
    "Property",
    "Other"
  ].freeze

  belongs_to :user
  has_many :answers, dependent: :destroy

  enum :status, { open: 0, answered: 1, closed: 2 }

  validates :title, :body, :category, presence: true
  validates :category, inclusion: { in: CATEGORIES }
end
