# frozen_string_literal: true

RSpec.describe Api::V1::Task::Operation::Index do
  let(:result) { described_class.call(params: params, current_user: user) }
  let(:user) { create(:user) }
  let(:project) { create(:project, :with_tasks, user: user) }

  describe '.call' do
    context 'when params are valid' do
      let(:params) { { project_id: project.id } }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:ok)
      end

      it 'assigns project tasks to result context' do
        expect(result[:relation]).to match(project.tasks)
      end
    end

    context 'when project id invalid' do
      let(:params) { { project_id: nil } }

      it 'operation result failed' do
        expect(result).to be_failure
        expect(result[:semantic_failure]).to eq(:not_found)
      end
    end
  end
end
