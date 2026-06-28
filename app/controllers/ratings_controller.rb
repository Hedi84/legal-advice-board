class RatingsController < ApplicationController
  before_action :require_user!
  before_action :set_answer
  before_action :require_rating_permission!

def create
  @rating = @answer.build_rating(rating_params)
  @rating.user = current_user
  @rating.rated_at = Time.current

  if @rating.save
    @answer.reload
    respond_to_rating_success
  else
    redirect_to question_path(@answer.question),
                alert: @rating.errors.full_messages.to_sentence
  end
end

  private

  def set_answer
    @answer = Answer.find(params[:answer_id])
  end

  def require_rating_permission!
    return if @permissions.rate_answer?(@answer)

    redirect_to question_path(@answer.question), alert: "Not authorised."
  end

  def rating_params
    params.permit(:rating)
  end

  def respond_to_rating_success
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "answer_#{@answer.id}",
          partial: "answers/answer",
          locals: { answer: @answer }
        )
      end

      format.html { redirect_to question_path(@answer.question) }
    end
  end
end
