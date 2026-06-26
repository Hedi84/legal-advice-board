class User < ApplicationRecord
  has_secure_password

  enum :role, {
    user: 0,
    lawyer: 1,
    admin: 2
  }

  has_many :questions, dependent: :destroy
  has_many :answers, foreign_key: :lawyer_id, dependent: :destroy
  has_many :payments, foreign_key: :requester_id, dependent: :destroy

  normalizes :email_address, with: ->(email_address) { email_address.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :role, presence: true
end
