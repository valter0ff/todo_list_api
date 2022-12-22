# frozen_string_literal: true

RSpec.describe Api::V1::Comment::Operation::Create do
  let(:result) { described_class.call(params: params, current_user: task.project.user) }
  let(:task) { create(:task) }
  let(:params) { { task_id: task_id, comment: { body: body, image: image } } }
  let(:task_id) { task.id }
  let(:body) { FFaker::Name.unique.name }
  let(:image) { attributes_for(:comment, :with_image)[:image] }

  describe '.call' do
    describe 'succes' do
      context 'when params are valid' do
        it 'operation result successfull' do
          expect(result).to be_success
          expect(result[:semantic_success]).to eq(:created)
          expect(result[:model]).to be_persisted
        end

        it 'creates new task in database' do
          expect { result }.to change(Comment, :count).by(1)
        end
      end
    end

    describe 'failure' do
      let(:result_errors) { result['contract.default'].errors.messages }

      context 'when comment body is invalid' do
        let(:body) { nil }
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
      end

      context 'when task id is invalid' do
        let(:task_id) { nil }

        it 'operation result failed' do
          expect(result).to be_failure
          expect(result[:semantic_failure]).to eq(:not_found)
        end
      end

      context 'when params haven`t key `comment`' do
        let(:params) { { task_id: task_id, body: body, image: image } }
        let(:unprocessable_request_error) { I18n.t('errors.unprocessable') }

        it 'operation result failed' do
          expect(result).to be_failure
          expect(result_errors[:base]).to eq(unprocessable_request_error)
        end
      end
    end
  end
end
