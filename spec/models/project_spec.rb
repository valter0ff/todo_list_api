# frozen_string_literal: true

RSpec.describe Project, type: :model do
  subject(:project) { create(:project) }

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
