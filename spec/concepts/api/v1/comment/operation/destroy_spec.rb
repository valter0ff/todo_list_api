# frozen_string_literal: true

RSpec.describe Api::V1::Comment::Operation::Destroy do
  let(:result) { described_class.call(params: params, current_user: task.project.user) }
  let(:task) { create(:task) }
  let!(:comment) { create(:comment, task: task) }

  describe '.call' do
    describe 'succes' do
      context 'when params are valid' do
        let(:params) { { id: comment.id } }

        it 'operation result successfull' do
          expect(result).to be_success
          expect(result[:semantic_success]).to eq(:destroyed)
        end

        it 'deletes comment from database' do
          expect { result }.to change(Comment, :count).by(-1)
        end
      end
    end

    describe 'failure' do
      context 'when comment id is invalid' do
        let(:params) { { id: rand(2..100) } }

        it 'operation result failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end

        it 'doesn`t delete comment from database' do
          expect { result }.not_to change(Comment, :count)
        end
      end

      context 'when comment doesn`t belong to current user' do
        let!(:another_comment) { create(:comment) }
        let(:params) { { id: another_comment.id } }

        it 'operation result failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end

        it 'doesn`t delete comment from database' do
          expect { result }.not_to change(Comment, :count)
        end
      end
    end
  end
end
