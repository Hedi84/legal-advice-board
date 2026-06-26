class Payment < ApplicationRecord
  belongs_to :answer
  belongs_to :requester, class_name: "User"

  enum :status, { pending: 0, paid: 1 }
end
