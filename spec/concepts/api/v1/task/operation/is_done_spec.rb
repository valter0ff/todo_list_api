# frozen_string_literal: true

RSpec.describe Api::V1::Task::Operation::IsDone do
  let(:result) { described_class.call(params: params, current_user: user) }
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }

  describe '.call' do
    context 'when params are valid' do
      let(:params) { { id: task.id } }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:ok)
        expect(result[:model]).to be_persisted
      end

      it 'updates task`s status' do
        expect(result[:model]).to be_is_done
      end
    end

    context 'when task id is invalid' do
      let(:params) { { id: rand(2..100) } }

      it 'operation result failed' do
        expect(result).to be_failure
        expect(result[:semantic_failure]).to eq(:not_found)
      end
    end
  end
end
