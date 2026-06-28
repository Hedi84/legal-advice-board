require 'rails_helper'

RSpec.describe "Payments", type: :request do
  let(:user)    { create(:user) }
  let(:lawyer)  { create(:user, role: :lawyer) }
  let!(:answer)  { create(:answer, lawyer: lawyer) }
  let!(:payment) { create(:payment, answer: answer, requester: user) }

  def login
    post login_path, params: { email_address: user.email_address, password: "password123" }
  end

  context "when not logged in" do
    it "redirects PATCH /payments/:id to login" do
      patch payment_path(payment)
      expect(response).to redirect_to(login_path)
    end
  end

  context "when logged in as the question owner" do
    before do
      answer.question.update!(user: user)
      login
    end

    it "processes the payment and redirects to the question" do
      patch payment_path(payment)
      expect(response).to redirect_to(question_path(answer.question))
    end

    it "marks the payment as paid" do
      expect { patch payment_path(payment) }.to change { payment.reload.status }.to("paid")
    end

    it "marks the question as answered" do
      expect { patch payment_path(payment) }.to change { answer.question.reload.status }.to("answered")
    end

    it "cannot pay twice" do
      payment.update!(status: :paid)
      patch payment_path(payment)
      expect(response).to redirect_to(questions_path)
    end
  end

  context "when logged in as a different user" do
    let(:other_user) { create(:user) }

    before do
      post login_path, params: { email_address: other_user.email_address, password: "password123" }
    end

    it "cannot pay for another user's question" do
      patch payment_path(payment)
      expect(response).to redirect_to(questions_path)
    end
  end
end
