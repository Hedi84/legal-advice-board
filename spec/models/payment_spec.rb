require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject(:payment) { build(:payment) }

  describe "validations" do
    it { is_expected.to belong_to(:answer) }
    it { is_expected.to belong_to(:requester) }
  end

  describe "status" do
    it "defaults to pending" do
      expect(payment.status).to eq("pending")
    end

    it "can be set to paid" do
      payment.status = :paid
      expect(payment).to be_paid
    end
  end
end
