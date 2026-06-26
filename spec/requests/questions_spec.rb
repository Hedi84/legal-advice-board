require 'rails_helper'

RSpec.describe "Questions", type: :request do
  let(:user)         { create(:user) }
  let!(:question)    { create(:question, user: user) }
  let(:valid_params) { { question: attributes_for(:question) } }

  def login
    post login_path, params: { email_address: user.email_address, password: "password123" }
  end

  context "when not logged in" do
    it "redirects GET /questions to login" do
      get questions_path
      expect(response).to redirect_to(login_path)
    end

    it "redirects GET /questions/new to login" do
      get new_question_path
      expect(response).to redirect_to(login_path)
    end

    it "redirects POST /questions to login" do
      post questions_path, params: valid_params
      expect(response).to redirect_to(login_path)
    end

    it "redirects DELETE /questions/:id to login" do
      delete question_path(question)
      expect(response).to redirect_to(login_path)
    end
  end

  context "when logged in as a regular user" do
    before { login }

    it "can view the index" do
      get questions_path
      expect(response).to have_http_status(:ok)
    end

    it "can view the new question form" do
      get new_question_path
      expect(response).to have_http_status(:ok)
    end

    it "can create a question" do
      expect { post questions_path, params: valid_params }.to change(Question, :count).by(1)
      expect(response).to redirect_to(questions_path)
    end

    it "re-renders the form with 422 on invalid params" do
      post questions_path, params: { question: attributes_for(:question, title: "") }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "can delete their own question" do
      expect { delete question_path(question) }.to change(Question, :count).by(-1)
      expect(response).to redirect_to(questions_path)
    end

    it "cannot delete another user's question" do
      other_question = create(:question)
      expect { delete question_path(other_question) }.not_to change(Question, :count)
      expect(response).to redirect_to(questions_path)
    end
  end

  context "when logged in as a lawyer" do
    before do
      user.update!(role: :lawyer)
      login
    end

    it "can view the index" do
      get questions_path
      expect(response).to have_http_status(:ok)
    end

    it "cannot access the new question form" do
      get new_question_path
      expect(response).to redirect_to(questions_path)
    end

    it "cannot create a question" do
      expect { post questions_path, params: valid_params }.not_to change(Question, :count)
      expect(response).to redirect_to(questions_path)
    end
  end

  context "when logged in as an admin" do
    before do
      user.update!(role: :admin)
      login
    end

    it "can view the index" do
      get questions_path
      expect(response).to have_http_status(:ok)
    end

    it "can view the new question form" do
      get new_question_path
      expect(response).to have_http_status(:ok)
    end

    it "can create a question" do
      expect { post questions_path, params: valid_params }.to change(Question, :count).by(1)
      expect(response).to redirect_to(questions_path)
    end

    it "can delete any question" do
      expect { delete question_path(question) }.to change(Question, :count).by(-1)
      expect(response).to redirect_to(questions_path)
    end
  end
end
