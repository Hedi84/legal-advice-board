class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :logged_in?
  before_action :permissions

  def permissions
    @permissions ||= UserPermissions.new(current_user)
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_user!
    redirect_to login_path, alert: "The email or password is incorrect, please try again." unless logged_in?
  end
end
