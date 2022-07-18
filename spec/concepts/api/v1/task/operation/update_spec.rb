# frozen_string_literal: true

RSpec.describe Api::V1::Task::Operation::Update do
  let(:result) { described_class.call(params: params, current_user: user) }
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, name: name, project: project) }
  let(:name) { FFaker::Name.unique.name }

  describe '.call' do
    context 'when params are valid' do
      let(:params) { { id: task.id, task: { name: new_name } } }
      let(:new_name) { FFaker::Name.unique.name }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:ok)
        expect(result[:model]).to be_persisted
      end

      it 'updates task title' do
        expect { result }.to change { task.reload.name }.from(name).to(new_name)
      end
    end

    context 'when task id is invalid' do
      let(:params) { { id: rand(2..100), task: { name: FFaker::Name.unique.name } } }

      it 'operation result failed' do
        expect(result).to be_failure
        expect(result[:semantic_failure]).to eq(:not_found)
      end
    end

    context 'when task name is blank' do
      let(:params) { { id: task.id, task: { name: '' } } }
      let(:result_errors) { result['contract.default'].errors.messages }
      let(:empty_name_error) { I18n.t('errors.rules.task.rules.name.filled?') }

      it 'operation result failed' do
        expect(result).to be_failure
      end

      it 'assigns errors to result errors hash' do
        expect(result_errors).not_to be_empty
        expect(result_errors[:name].first).to eq(empty_name_error)
      end
    end

    context 'when task status `is_done`' do
      let(:task) { create(:task, :is_done, project: project) }
      let(:params) { { id: task.id, task: { name: FFaker::Name.unique.name } } }
      let(:result_errors) { result['contract.default'].errors.messages }
      let(:task_complete_error) { I18n.t('errors.rules.task.rules.status.is_done?') }

      it 'operation result failed' do
        expect(result).to be_failure
      end

      it 'assigns errors to result errors hash' do
        expect(result_errors).not_to be_empty
        expect(result_errors[:status].first).to eq(task_complete_error)
      end
    end
  end
end
