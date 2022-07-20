# frozen_string_literal: true

RSpec.describe Api::V1::Task::Contract::SetDeadline do
  let(:contract) { described_class.new(task) }

  describe 'attributes validations' do
    before { contract.validate(params) }

    context 'when params are valid' do
      let(:task) { create(:task) }
      let(:params) { attributes_for(:task) }

      it 'contract does not have errors' do
        expect(contract.errors).to be_empty
      end
    end

    context 'when deadline is blank' do
      let(:task) { create(:task) }
      let(:params) { { deadline: '' } }
      let(:deadline_blank_error) { I18n.t('errors.rules.task.rules.deadline.filled?') }

      it 'returns errors' do
        expect(contract.errors.messages[:deadline].first).to eq(deadline_blank_error)
      end
    end

    context 'when deadline date less than time now' do
      let(:task) { create(:task) }
      let(:params) { { deadline: DateTime.now.prev_week.to_s } }
      let(:deadline_past_error) { I18n.t('errors.rules.task.rules.deadline.gteq?') }

      it 'returns errors' do
        expect(contract.errors.messages[:deadline].first).to eq(deadline_past_error)
      end
    end

    context 'when task status `is_done`' do
      let(:task) { create(:task, :is_done) }
      let(:params) { attributes_for(:task) }
      let(:task_complete_error) { I18n.t('errors.rules.task.rules.status.is_done?') }

      it 'returns errors' do
        expect(contract.errors.messages[:status].first).to eq(task_complete_error)
      end
    end
  end
end
