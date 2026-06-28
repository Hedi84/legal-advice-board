class RatingsController < ApplicationController
  before_action :require_user!

  def create
    @answer = Answer.find(params[:answer_id])

    unless @permissions.rate_answer?(@answer)
      redirect_to question_path(@answer.question), alert: "Not authorised." and return
    end

    @rating = Rating.new(
      answer: @answer,
      user: current_user,
      rating: params[:rating],
      rated_at: Time.current
    )

    if @rating.save
    else
    end
  end
end
