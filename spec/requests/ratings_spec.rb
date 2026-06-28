require 'rails_helper'

RSpec.describe "Ratings", type: :request do
  let(:user)    { create(:user) }
  let(:lawyer)  { create(:user, role: :lawyer) }
  let!(:answer)  { create(:answer, lawyer: lawyer, question: create(:question, user: user)) }
  let!(:payment) { create(:payment, answer: answer, requester: user, status: :paid) }

  def login
    post login_path, params: { email_address: user.email_address, password: "password123" }
  end

  context "when not logged in" do
    it "redirects POST /ratings to login" do
      post ratings_path, params: { answer_id: answer.id, rating: 4 }
      expect(response).to redirect_to(login_path)
    end
  end

  context "when logged in as the question owner" do
    before { login }

    it "creates a rating" do
      expect { post ratings_path, params: { answer_id: answer.id, rating: 4 } }
        .to change(Rating, :count).by(1)
    end

    it "redirects to the question" do
      post ratings_path, params: { answer_id: answer.id, rating: 4 }
      expect(response).to redirect_to(question_path(answer.question))
    end

    it "cannot rate the same answer twice" do
      create(:rating, answer: answer, user: user)
      expect { post ratings_path, params: { answer_id: answer.id, rating: 3 } }
        .not_to change(Rating, :count)
    end
  end

  context "when logged in as a different user" do
    let(:other_user) { create(:user) }

    before do
      post login_path, params: { email_address: other_user.email_address, password: "password123" }
    end

    it "cannot rate another user's answer" do
      expect { post ratings_path, params: { answer_id: answer.id, rating: 5 } }
        .not_to change(Rating, :count)
      expect(response).to redirect_to(question_path(answer.question))
    end
  end

  context "when logged in as a lawyer" do
    before do
      user.update!(role: :lawyer)
      login
    end

    it "cannot submit a rating" do
      expect { post ratings_path, params: { answer_id: answer.id, rating: 5 } }
        .not_to change(Rating, :count)
    end
  end
end
