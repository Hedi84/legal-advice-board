require 'rails_helper'

RSpec.describe UserPermissions do
  let(:user)        { build(:user) }
  let(:permissions) { described_class.new(user) }

  context "when the user is a regular user" do
    it { expect(permissions.create_questions?).to be true }
    it { expect(permissions.view_all_questions?).to be false }
    it { expect(permissions.delete_question?(build(:question, user: user))).to be true }
    it { expect(permissions.delete_question?(build(:question))).to be false }
    it { expect(permissions.view_answer_full?(build(:answer))).to be false }

    it "can view a paid answer" do
      answer = create(:answer)
      create(:payment, answer: answer, status: :paid)
      expect(permissions.view_answer_full?(answer.reload)).to be true
    end
  end

  context "when the user is a lawyer" do
    before { user.role = :lawyer }

    it { expect(permissions.create_questions?).to be false }
    it { expect(permissions.view_all_questions?).to be true }
    it { expect(permissions.delete_question?(build(:question))).to be false }
    it { expect(permissions.view_answer_full?(build(:answer))).to be false }
    it { expect(permissions.view_answer_full?(build(:answer, lawyer: user))).to be true }
  end

  context "when the user is an admin" do
    before { user.role = :admin }

    it { expect(permissions.create_questions?).to be true }
    it { expect(permissions.view_all_questions?).to be true }
    it { expect(permissions.delete_question?(build(:question, user: user))).to be true }
    it { expect(permissions.delete_question?(build(:question))).to be true }
    it { expect(permissions.view_answer_full?(build(:answer))).to be true }
  end
end
