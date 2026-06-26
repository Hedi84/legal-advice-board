class Question < ApplicationRecord
  belongs_to :user

  enum :status, {
    open: 0,
    answered: 1,
    closed: 2
  }

  validates :title, :body, :category, presence: true
end
