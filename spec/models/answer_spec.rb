require 'rails_helper'

RSpec.describe Answer, type: :model do
  subject(:answer) { build(:answer) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:response) }
    it { is_expected.to belong_to(:question) }
    it { is_expected.to belong_to(:lawyer) }

    it { is_expected.to validate_numericality_of(:fee_pounds).only_integer.is_greater_than(0) }
  end
end
