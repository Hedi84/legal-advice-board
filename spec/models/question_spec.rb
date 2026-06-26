require 'rails_helper'

RSpec.describe Question, type: :model do
  subject(:question) { build(:question) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to belong_to(:user) }
  end

  describe "status" do
    it "defaults to open" do
      expect(question.status).to eq("open")
    end

    it "can be set to answered" do
      question.status = :answered
      expect(question).to be_answered
    end

    it "can be set to closed" do
      question.status = :closed
      expect(question).to be_closed
    end
  end

  describe "associations" do
    it "is destroyed when its user is destroyed" do
      user = create(:user)
      create(:question, user: user)
      expect { user.destroy }.to change(Question, :count).by(-1)
    end
  end
end
