# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])

    # safe navigation in case user does not exist
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Signed in successfully."
    else
      redirect_to root_path, alert: "Invalid email address or password."
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Signed out successfully."
  end
end
