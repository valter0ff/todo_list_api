# frozen_string_literal: true

RSpec.describe Api::V1::Task::Operation::SetDeadline do
  let(:result) { described_class.call(params: params, current_user: user) }
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, deadline: deadline, project: project) }
  let(:deadline) { DateTime.now.end_of_hour.utc.to_s }

  describe '.call' do
    context 'when params are valid' do
      let(:params) { { id: task.id, task: { deadline: new_deadline } } }
      let(:new_deadline) { DateTime.now.tomorrow.utc.to_s }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:ok)
        expect(result[:model]).to be_persisted
      end

      it 'updates task title' do
        expect { result }.to change { task.reload.deadline.to_datetime.utc.to_s }.from(deadline).to(new_deadline)
      end
    end

    context 'when task id is invalid' do
      let(:params) { { id: rand(2..100), task: { deadline: DateTime.now.next_month.to_s } } }

      it 'operation result failed' do
        expect(result).to be_failure
        expect(result[:semantic_failure]).to eq(:not_found)
      end
    end

    context 'when task deadline is blank' do
      let(:params) { { id: task.id, task: { deadline: '' } } }
      let(:result_errors) { result['contract.default'].errors.messages }
      let(:empty_deadline_error) { I18n.t('errors.rules.task.rules.deadline.filled?') }

      it 'operation result failed' do
        expect(result).to be_failure
      end

      it 'assigns errors to result errors hash' do
        expect(result_errors).not_to be_empty
        expect(result_errors[:deadline].first).to eq(empty_deadline_error)
      end
    end

    context 'when task deadline less than time now' do
      let(:params) { { id: task.id, task: { deadline: DateTime.now.prev_week.to_s } } }
      let(:result_errors) { result['contract.default'].errors.messages }
      let(:deadline_in_past_error) { I18n.t('errors.rules.task.rules.deadline.gteq?') }

      it 'operation result failed' do
        expect(result).to be_failure
      end

      it 'assigns errors to result errors hash' do
        expect(result_errors).not_to be_empty
        expect(result_errors[:deadline].first).to eq(deadline_in_past_error)
      end
    end

    context 'when task status `is_done`' do
      let(:task) { create(:task, :done, project: project) }
      let(:params) { { id: task.id, task: { deadline: DateTime.now.next_month.to_s } } }
      let(:result_errors) { result['contract.default'].errors.messages }
      let(:task_complete_error) { I18n.t('errors.rules.task.rules.status.in_progress?') }

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
