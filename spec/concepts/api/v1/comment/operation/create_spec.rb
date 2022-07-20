# frozen_string_literal: true

RSpec.describe Api::V1::Comment::Operation::Create do
  let(:result) { described_class.call(params: params, current_user: user) }
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }

  describe '.call' do
    context 'when params are valid' do
      let(:params) { { task_id: task.id, comment: attributes_for(:comment) } }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:created)
        expect(result[:model]).to be_persisted
      end

      it 'creates new task in database' do
        expect { result }.to change(Comment, :count).by(1)
      end
    end

    context 'when comment body is invalid' do
      let(:params) { { task_id: task.id, comment: { body: nil } } }
      let(:result_errors) { result['contract.default'].errors.messages }
      let(:empty_body_error) { I18n.t('errors.filled?') }

      it 'operation result failed' do
        expect(result).to be_failure
      end

      it 'assigns errors to result errors hash' do
        expect(result_errors).not_to be_empty
        expect(result_errors[:body].first).to eq(empty_body_error)
      end

      it 'doesn`t create new task in database' do
        expect { result }.not_to change(Comment, :count)
      end

      context 'when task id is invalid' do
        let(:params) { { task_id: nil, comment: attributes_for(:comment) } }

        it 'operation result failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end
      end

      context 'when params haven`t key `comment`' do
        let(:params) { { task_id: task.id, body: FFaker::Lorem.word } }
        let(:unprocessable_request_error) { I18n.t('errors.unprocessable') }

        it 'operation result failed' do
          expect(result).to be_failure
          expect(result_errors[:base]).to eq(unprocessable_request_error)
        end
      end
    end
  end
end
