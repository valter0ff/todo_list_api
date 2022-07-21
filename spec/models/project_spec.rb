# frozen_string_literal: true

RSpec.describe Project, type: :model do
  subject(:project) { create(:project) }

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end
end
