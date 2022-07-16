# frozen_string_literal: true

RSpec.describe User, type: :model do
  subject(:user_account) { create(:user) }

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:username).of_type(:string) }
    it { is_expected.to have_db_column(:password_digest).of_type(:string) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:username) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:projects).dependent(:destroy) }
  end
end
