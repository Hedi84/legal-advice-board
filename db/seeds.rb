User.create!(
  name: "Test User",
  email_address: "user@example.com",
  password: "password",
  role: :user
)

User.create!(
  name: "Lawyer",
  email_address: "lawyer@example.com",
  password: "password",
  role: :lawyer
)
