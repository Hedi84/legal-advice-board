class UserPermissions
  def initialize(user)
    @user = user
  end

  def create_questions?
    user.user? || user.admin?
  end

  def create_answers?
    user.lawyer? || user.admin?
  end

  def view_all_questions?
    user.lawyer? || user.admin?
  end

  def view_answer_full?(answer)
    user.admin? || answer.payment&.paid?
  end

  def pay_for_answer?(answer)
    user.user? &&
      answer.question.user == user &&
      answer.payment.present? &&
      !answer.payment.paid?
  end

  def close_question?(question)
    user.admin? || (user.user? && question.user == user)
  end

  def delete_question?(question)
    user.admin? || question.user == user
  end

  private

  attr_reader :user
end
