# frozen_string_literal: true

RSpec.describe Api::V1::Project::Operation::Create do
  let(:result) { described_class.call(params: params, current_user: user) }
  let(:user) { create(:user) }

  describe '.call' do
    context 'when params are valid' do
      let(:params) { { project: attributes_for(:project) } }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:created)
        expect(result[:model]).to be_persisted
      end

      it 'creates new project in database' do
        expect { result }.to change(Project, :count).by(1)
      end
    end

    context 'when params are invalid' do
      let(:params) { { project: {} } }
      let(:result_errors) { result['contract.default'].errors.messages }
      let(:empty_title_error) { I18n.t('errors.rules.project.rules.title.filled?') }

      it 'operation result failed' do
        expect(result).to be_failure
      end

      it 'assigns errors to result errors hash' do
        expect(result_errors).not_to be_empty
        expect(result_errors[:title].first).to eq(empty_title_error)
      end

      it 'doesn`t create new project in database' do
        expect { result }.not_to change(Project, :count)
      end

      context 'when params hasn`t key `project`' do
        let(:params) { {} }
        let(:unprocessable_request_error) { I18n.t('errors.unprocessable') }

        it 'operation result failed' do
          expect(result).to be_failure
          expect(result_errors[:base]).to eq(unprocessable_request_error)
        end
      end
    end
  end
end
