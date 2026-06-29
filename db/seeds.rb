# ── Cleanup ───────────────────────────────────────────────────────────────────

Rating.destroy_all
Payment.destroy_all
Answer.destroy_all
Question.destroy_all
User.destroy_all

# ── Users ────────────────────────────────────────────────────────────────────

test_user = User.create!(
  name: "Test User",
  email_address: "user@example.com",
  password: "password",
  role: :user
)

alice = User.create!(
  name: "Alice Hartley",
  email_address: "alice@example.com",
  password: (alice_pw = SecureRandom.hex(8)),
  role: :user
)

marcus = User.create!(
  name: "Marcus Webb",
  email_address: "marcus@example.com",
  password: (marcus_pw = SecureRandom.hex(8)),
  role: :user
)

priya = User.create!(
  name: "Priya Nair",
  email_address: "priya@example.com",
  password: (priya_pw = SecureRandom.hex(8)),
  role: :user
)

tom = User.create!(
  name: "Tom Brennan",
  email_address: "tom@example.com",
  password: (tom_pw = SecureRandom.hex(8)),
  role: :user
)

# ── Lawyers ───────────────────────────────────────────────────────────────────

main_lawyer = User.create!(
  name: "Lawyer",
  email_address: "lawyer@example.com",
  password: "password",
  role: :lawyer
)

claire = User.create!(
  name: "Claire Mossop",
  email_address: "claire@example.com",
  password: (claire_pw = SecureRandom.hex(8)),
  role: :lawyer
)

james = User.create!(
  name: "James Whitfield",
  email_address: "james@example.com",
  password: (james_pw = SecureRandom.hex(8)),
  role: :lawyer
)

fatima = User.create!(
  name: "Fatima Al-Hassan",
  email_address: "fatima@example.com",
  password: (fatima_pw = SecureRandom.hex(8)),
  role: :lawyer
)

richard = User.create!(
  name: "Richard Okafor",
  email_address: "richard@example.com",
  password: (richard_pw = SecureRandom.hex(8)),
  role: :lawyer
)

# ── Admin ─────────────────────────────────────────────────────────────────────

User.create!(
  name: "Admin",
  email_address: "admin@example.com",
  password: 'password',
  role: :admin
)

# ── Questions ─────────────────────────────────────────────────────────────────

test_question = test_user.questions.create!(
  title: "Can my employer cut my pay without notice?",
  body: "I have been told by my manager that my hourly rate is being reduced " \
        "from next week. I have not signed anything and was given no written " \
        "notice. Is this legal?",
  category: "Employment"
)

alice_question = alice.questions.create!(
  title: "My landlord is refusing to return my deposit",
  body: "I moved out of my flat three weeks ago in good condition. My landlord " \
        "says there was damage but has provided no evidence and is keeping the " \
        "full £1,200 deposit. What can I do?",
  category: "Housing"
)

marcus_question = marcus.questions.create!(
  title: "What are my rights during a divorce regarding the family home?",
  body: "My wife and I are separating after 11 years. We jointly own our home. " \
        "She wants to sell immediately but I would like to stay with the " \
        "children. What are my options?",
  category: "Family"
)

priya_question = priya.questions.create!(
  title: "Is a handwritten will legally valid?",
  body: "My father passed away last month and left a handwritten will that was " \
        "not witnessed. He left everything to me and my brother equally. Will " \
        "this hold up in court?",
  category: "Wills and Probate"
)

tom_question = tom.questions.create!(
  title: "Can my neighbour build a fence on the boundary line?",
  body: "My neighbour has started building a fence and claims the boundary runs " \
        "through my garden. I have the original deeds showing otherwise. What " \
        "steps should I take?",
  category: "Property"
)

# ── Answers from all lawyers to all questions ─────────────────────────────────

answer_body =
  "Thank you for your question. Based on the information provided, you have " \
  "a number of options available to you. I would recommend seeking formal " \
  "advice at the earliest opportunity to protect your position. Please feel " \
  "free to follow up with any additional details."

questions = [ test_question, alice_question, marcus_question, priya_question, tom_question ]
lawyers   = [ main_lawyer, claire, james, fatima, richard ]

questions.each do |question|
  lawyers.each do |lawyer|
    answer = question.answers.create!(
      lawyer: lawyer,
      response: answer_body,
      proposed_fee_pounds: [ 35.00, 49.95, 75.50, 100.00, 125.00 ].sample
    )
    answer.create_payment!(requester: question.user, status: :pending)
  end
end

# ── One paid + open (not test user or main lawyer) ────────────────────────────

alice_question.answers.find_by(lawyer: claire).payment.update!(
  status: :paid,
  approved_at: 2.days.ago
)
alice_question.update!(status: :answered)

# ── One paid + closed (not test user or main lawyer) ─────────────────────────

marcus_question.answers.find_by(lawyer: james).payment.update!(
  status: :paid,
  approved_at: 5.days.ago
)
marcus_question.update!(status: :closed)

# ── Ratings for paid answers ──────────────────────────────────────────────────

alice_question.answers.find_by(lawyer: claire).create_rating!(
  user: alice,
  rating: rand(1..5),
  rated_at: 1.day.ago
)

marcus_question.answers.find_by(lawyer: james).create_rating!(
  user: marcus,
  rating: rand(1..5),
  rated_at: 4.days.ago
)

# ── Generated passwords ───────────────────────────────────────────────────────

puts "\nSeed complete. Generated passwords:"
puts "  alice@example.com   → #{alice_pw}"
puts "  marcus@example.com  → #{marcus_pw}"
puts "  priya@example.com   → #{priya_pw}"
puts "  tom@example.com     → #{tom_pw}"
puts "  claire@example.com  → #{claire_pw}"
puts "  james@example.com   → #{james_pw}"
puts "  fatima@example.com  → #{fatima_pw}"
puts "  richard@example.com → #{richard_pw}"
