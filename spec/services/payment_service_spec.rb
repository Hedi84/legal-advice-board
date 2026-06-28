require 'rails_helper'

RSpec.describe PaymentService do
  let(:payment) { create(:payment) }

  subject(:pay) { PaymentService.new(payment).pay! }

  context 'when a payment is settled successfully' do
    it 'marks the payment as paid and records the timestamp' do
      expect { pay }
        .to change { payment.reload.status }.to("paid")
        .and change { payment.reload.approved_at }.from(nil)
    end

    it 'marks the question as answered' do
      expect { pay }.to change { payment.answer.question.reload.status }.to("answered")
    end
  end

  context 'when the payment update fails' do
    before { allow(payment).to receive(:update!).and_raise(ActiveRecord::RecordInvalid) }

    it 'raises an error' do
      expect { pay }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'does not update the question status' do
      pay rescue nil
      expect(payment.answer.question.reload.status).to eq("open")
    end

    it 'rolls back the payment status' do
      pay rescue nil
      expect(payment.reload.status).to eq("pending")
    end
  end

  context 'when the question update fails' do
    before do
      allow(payment.answer.question).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
    end

    it 'raises an error' do
      expect { pay }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'rolls back the payment status' do
      pay rescue nil
      expect(payment.reload.status).to eq("pending")
    end

    it 'does not update the question status' do
      pay rescue nil
      expect(payment.answer.question.reload.status).to eq("open")
    end
  end
end
