# frozen_string_literal: true

RSpec.describe Api::V1::Comment::Operation::Index do
  let(:result) { described_class.call(params: params, current_user: task.project.user) }
  let(:task) { create(:task, :with_comments) }

  describe '.call' do
    context 'when params are valid' do
      let(:params) { { task_id: task.id } }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:ok)
      end

      it 'assigns task comments to result context' do
        expect(result[:model_items]).to match(task.comments)
      end
    end

    context 'when task id is invalid' do
      let(:params) { { task_id: nil } }

      it 'operation result failed' do
        expect(result).to be_failure
        expect(result[:semantic_failure]).to eq(:not_found)
      end
    end
  end
end
