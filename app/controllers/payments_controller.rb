class PaymentsController < ApplicationController
  before_action :require_user!

  def update
    @payment = Payment.find(params[:id])

    unless @permissions.pay_for_answer?(@payment.answer)
      redirect_to questions_path, alert: "You are not authorised to make this payment."
      return
    end

    PaymentService.new(@payment).pay!
    @answer = @payment.answer.reload

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
