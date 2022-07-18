# frozen_string_literal: true

RSpec.describe Api::V1::Task::Operation::Create do
  let(:result) { described_class.call(params: params, current_user: user) }
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  describe '.call' do
    context 'when params are valid' do
      let(:params) { { project_id: project.id, task: attributes_for(:task) } }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:created)
        expect(result[:model]).to be_persisted
      end

      it 'creates new task in database' do
        expect { result }.to change(Task, :count).by(1)
      end
    end

    context 'when task name is invalid' do
      let(:params) { { project_id: project.id, task: { name: nil } } }
      let(:result_errors) { result['contract.default'].errors.messages }
      let(:empty_name_error) { I18n.t('errors.rules.task.rules.name.filled?') }

      it 'operation result failed' do
        expect(result).to be_failure
      end

      it 'assigns errors to result errors hash' do
        expect(result_errors).not_to be_empty
        expect(result_errors[:name].first).to eq(empty_name_error)
      end

      it 'doesn`t create new task in database' do
        expect { result }.not_to change(Task, :count)
      end

      context 'when project id is invalid' do
        let(:params) { { project_id: nil, task: attributes_for(:task) } }

        it 'operation result failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end
      end

      context 'when params haven`t key `task`' do
        let(:params) { { project_id: project.id, name: FFaker::Lorem.word } }
        let(:unprocessable_request_error) { I18n.t('errors.unprocessable') }

        it 'operation result failed' do
          expect(result).to be_failure
          expect(result_errors[:base]).to eq(unprocessable_request_error)
        end
      end
    end
  end
end
