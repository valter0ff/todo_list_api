# frozen_string_literal: true

RSpec.describe Task, type: :model do
  subject(:task) { create(:task) }

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:project_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end
end
