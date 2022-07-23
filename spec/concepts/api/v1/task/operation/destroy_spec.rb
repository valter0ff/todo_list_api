# frozen_string_literal: true

RSpec.describe Api::V1::Task::Operation::Destroy do
  let(:result) { described_class.call(params: params, current_user: task.project.user) }
  let!(:task) { create(:task) }

  describe '.call' do
    context 'when params are valid' do
      let(:params) { { id: task.id } }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:destroyed)
      end

      it 'deletes task from database' do
        expect { result }.to change(Task, :count).by(-1)
      end
    end

    context 'when task id is invalid' do
      let(:params) { { id: rand(2..100) } }

      it 'operation result failed' do
        expect(result).to be_failure
        expect(result[:semantic_failure]).to eq(:not_found)
      end

      it 'doesn`t delete task from database' do
        expect { result }.not_to change(Task, :count)
      end
    end
  end
end
