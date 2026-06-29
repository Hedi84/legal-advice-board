require 'rails_helper'

RSpec.describe "User question flow", type: :feature do
  let(:user)   { create(:user) }
  let(:lawyer) { create(:user, role: :lawyer) }

  before { login_as(user) }

  it "creates a question and sees it open on the index" do
    click_link "Ask a Question"
    fill_in "Title", with: "Can my landlord do this?"
    select "Housing", from: "Category"
    fill_in "Details", with: "My landlord has told me I need to leave within 7 days."
    click_button "Submit question"

    expect(page).to have_content("Can my landlord do this?")
    expect(page).to have_css(".status-badge--open", text: "Open")
  end

  it "does not see another user's question" do
    create(:question, user: create(:user), title: "Someone else's question")
    visit questions_path
    expect(page).not_to have_content("Someone else's question")
  end

  context "with a lawyer's answer" do
    let!(:question) { create(:question, user: user) }
    let!(:answer)   { create(:answer, question: question, lawyer: lawyer) }
    let!(:payment)  { create(:payment, answer: answer, requester: user) }

    it "pays for an answer and reveals the legal advice" do
      visit question_path(question)

      expect(page).to have_content("This answer is locked.")

      click_button "Pay £#{answer.proposed_fee_pounds}"

      expect(page).to have_content(answer.response)
      expect(page).to have_css(".answer-card__paid", text: "Paid ✓")
      expect(payment.reload.status).to eq("paid")
      expect(page).to have_content("Rate this answer:")

      visit question_path(question)
      expect(page).to have_css(".status-badge--answered", text: "Answered")
    end
  end
end
