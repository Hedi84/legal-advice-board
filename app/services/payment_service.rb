class PaymentService
  def initialize(payment)
    @payment = payment
  end

  def pay!
    ActiveRecord::Base.transaction do
      @payment.update!(status: :paid, approved_at: Time.current)
      # a question's status is only changed to 'answered' after
      # the user pays for at least one answer
      question = @payment.answer.question
      question.update!(status: :answered) unless question.answered?
    end
  end
end
