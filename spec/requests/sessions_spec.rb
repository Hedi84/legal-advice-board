require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user, email_address: "alice@example.com", password: "password123") }

  describe "GET /login" do
    it "renders the login form" do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /login" do
    context "with valid credentials" do
      it "sets the session and redirects to root" do
        post login_path, params: { email_address: user.email_address, password: "password123" }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
      end
    end

    context "with wrong password" do
      it "does not set the session and re-renders the form" do
        post login_path, params: { email_address: user.email_address, password: "wrongpassword" }
        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with unknown email" do
      it "does not set the session and re-renders the form" do
        post login_path, params: { email_address: "nobody@example.com", password: "password123" }
        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /logout" do
    before { post login_path, params: { email_address: user.email_address, password: "password123" } }

    it "clears the session and redirects to login" do
      delete logout_path
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(login_path)
    end
  end
end
