# frozen_string_literal: true

RSpec.describe Comment, type: :model do
  subject(:comment) { create(:comment) }

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:body).of_type(:text) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(:task_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:task) }
  end
end
