class QuestionsController < ApplicationController
  before_action :require_user!
  before_action :require_question_creator!, only: %i[new create]
  before_action :set_question, only: :destroy
  before_action :require_question_deleter!, only: :destroy

  def index
    @questions = if @permissions.view_all_questions?
                   Question.all
    else
                   current_user.questions
    end.order(created_at: :desc)
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to questions_path, notice: "Question submitted successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: "Question deleted."
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def require_question_creator!
    return if @permissions.create_questions?

    redirect_to questions_path, alert: "You are not authorised to create questions."
  end

  def require_question_deleter!
    return if @permissions.delete_question?(@question)

    redirect_to questions_path, alert: "You are not authorised to delete this question."
  end

  def question_params
    params.require(:question).permit(:title, :body, :category)
  end
end
