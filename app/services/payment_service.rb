class PaymentService
  def initialize(payment)
    @payment = payment
  end

  def pay!
    ActiveRecord::Base.transaction do
      @payment.update!(status: :paid, approved_at: Time.current)
      @payment.answer.question.update!(status: :answered)
    end
  end
end
