class UserPermissions
  def initialize(user)
    @user = user
  end

  def create_questions?
    user.user? || user.admin?
  end

  def view_all_questions?
    user.lawyer? || user.admin?
  end

  def delete_question?(question)
    user.admin? || question.user == user
  end

  private

  attr_reader :user
end
