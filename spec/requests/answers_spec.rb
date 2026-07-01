require 'rails_helper'

RSpec.describe "Answers", type: :request do
  let(:user)         { create(:user) }
  let!(:question)    { create(:question, user: create(:user)) }
  let(:valid_params) { { answer: attributes_for(:answer) } }

  def login
    post login_path, params: { email_address: user.email_address, password: "password123" }
  end

  context "when not logged in" do
    it "redirects GET /questions/:id/answers/new to login" do
      get new_question_answer_path(question)
      expect(response).to redirect_to(login_path)
    end

    it "redirects POST /questions/:id/answers to login" do
      post question_answers_path(question), params: valid_params
      expect(response).to redirect_to(login_path)
    end
  end

  context "when logged in as a regular user" do
    before { login }

    it "cannot access the new answer form" do
      get new_question_answer_path(question)
      expect(response).to redirect_to(questions_path)
    end

    it "cannot submit an answer" do
      expect { post question_answers_path(question), params: valid_params }.not_to change(Answer, :count)
      expect(response).to redirect_to(questions_path)
    end
  end

  context "when logged in as a lawyer" do
    before do
      user.update!(role: :lawyer)
      login
    end

    it "can submit an answer" do
      expect { post question_answers_path(question), params: valid_params }.to change(Answer, :count).by(1)
      expect(response).to redirect_to(questions_path)
    end

    it "cannot submit a second answer to the same question" do
      create(:answer, question: question, lawyer: user)
      expect { post question_answers_path(question), params: valid_params }.not_to change(Answer, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "cannot submit an answer to a closed question" do
      question.update!(status: :closed)
      expect { post question_answers_path(question), params: valid_params }.not_to change(Answer, :count)
      expect(response).to redirect_to(question_path(question))
    end

    it "re-renders the form with 422 on invalid params" do
      post question_answers_path(question), params: { answer: attributes_for(:answer, response: "") }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  context "when two different lawyers answer the same question" do
    let(:lawyer_a) { create(:user, role: :lawyer) }
    let(:lawyer_b) { create(:user, role: :lawyer) }

    def login_as(u)
      post login_path, params: { email_address: u.email_address, password: "password123" }
    end

    it "both can submit an answer" do
      login_as(lawyer_a)
      expect { post question_answers_path(question), params: valid_params }.to change(Answer, :count).by(1)

      login_as(lawyer_b)
      expect { post question_answers_path(question), params: valid_params }.to change(Answer, :count).by(1)
    end
  end
end
