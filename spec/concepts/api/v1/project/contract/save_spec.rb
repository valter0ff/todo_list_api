# frozen_string_literal: true

RSpec.describe Api::V1::Project::Contract::Save do
  let(:contract) { described_class.new(Project.new(user: user)) }
  let(:user) { create(:user) }

  describe 'attributes validations' do
    let(:errors_path) { %w[errors rules project rules] }

    before { contract.validate(params) }

    context 'when params are valid' do
      let(:params) { attributes_for(:project) }

      it 'contract does not have errors' do
        expect(contract.errors).to be_empty
      end
    end

    context 'when title is blank' do
      let(:params) { { title: '' } }
      let(:title_blank_error) { I18n.t('title.filled?', scope: errors_path) }

      it 'returns errors' do
        expect(contract.errors.messages[:title].first).to eq(title_blank_error)
      end
    end

    context 'when title is not unique' do
      let(:project) { create(:project, user: user) }
      let(:params) { { title: project.title } }
      let(:title_unique_error) { I18n.t('title.unique_title?', scope: errors_path) }

      it 'returns error' do
        expect(contract.errors.messages[:title].first).to eq(title_unique_error)
      end

      context 'when title is not unique' do
        let!(:project) { create(:project) }
        let(:params) { { title: project.title } }
        let(:title_unique_error) { I18n.t('title.unique_title?', scope: errors_path) }

        it 'returns error' do
          expect(contract.errors.messages[:title].first).to eq(title_unique_error)
        end
      end
    end
  end
end
