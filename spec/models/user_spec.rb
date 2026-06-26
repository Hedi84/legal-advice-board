require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email_address) }
    it { is_expected.to validate_uniqueness_of(:email_address).case_insensitive }
    it { is_expected.to have_secure_password }
  end

  describe "roles" do
    it "defaults to user role" do
      expect(user.role).to eq("user")
    end

    it "can be set to lawyer" do
      user.role = :lawyer
      expect(user).to be_lawyer
    end

    it "can be set to admin" do
      user.role = :admin
      expect(user).to be_admin
    end
  end

  describe "email normalization" do
    it "strips whitespace and downcases the email address" do
      user.email_address = "  Alice@EXAMPLE.COM  "
      user.valid?
      expect(user.email_address).to eq("alice@example.com")
    end
  end
end
