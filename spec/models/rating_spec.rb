require 'rails_helper'

RSpec.describe Rating, type: :model do
  subject(:rating) { build(:rating) }

  describe "associations" do
    it { is_expected.to belong_to(:answer) }
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_inclusion_of(:rating).in_range(1..5) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:answer_id) }
  end
end
