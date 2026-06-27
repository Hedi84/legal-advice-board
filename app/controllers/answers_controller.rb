class AnswersController < ApplicationController
  before_action :require_user!
  before_action :require_answer_creator!
  before_action :set_question
  before_action :require_question_open!

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.lawyer = current_user

    # use a transaction here to make sure one never exists without the other
    if @answer.valid?
      ActiveRecord::Base.transaction do
        @answer.save!
        @answer.create_payment!(
          requester: @question.user,
          status: :pending
        )
      end

      redirect_to questions_path, notice: "Answer submitted. Payment request created."
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "Something went wrong while submitting the answer."
    render :new, status: :unprocessable_entity
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:response, :fee_pounds)
  end

  def require_answer_creator!
    return if @permissions.create_answers?

    redirect_to questions_path, alert: "You are not authorised to answer questions."
  end

  def require_question_open!
    return unless @question&.closed?

    redirect_to question_path(@question), alert: "This question is closed and no longer accepting answers."
  end
end
