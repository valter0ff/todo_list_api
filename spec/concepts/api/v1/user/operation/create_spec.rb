# frozen_string_literal: true

RSpec.describe Api::V1::User::Operation::Create do
  let(:result) { described_class.call(params: params) }

  describe '.call' do
    context 'when params are valid' do
      let(:params) { { user: attributes_for(:user) } }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:created)
        expect(result[:model]).to be_persisted
      end

      it 'creates new user in database' do
        expect { result }.to change(User, :count).by(1)
      end
    end

    context 'when params are invalid' do
      let(:params) { { user: {} } }
      let(:result_errors) { result['contract.default'].errors.messages }
      let(:empty_username_error) { I18n.t('errors.rules.user.rules.username.filled?') }
      let(:empty_password_error) { I18n.t('errors.rules.user.rules.password.filled?') }

      it 'operation result failed' do
        expect(result).to be_failure
      end

      it 'assigns errors to result errors hash' do
        expect(result_errors).not_to be_empty
        expect(result_errors[:username].first).to eq(empty_username_error)
        expect(result_errors[:password].first).to eq(empty_password_error)
      end

      it 'doesn`t create new user in database' do
        expect { result }.not_to change(User, :count)
      end
    
      context 'when params hasn`t key `user`' do
        let(:params) { {} }
        let(:unprocessable_request_error) { I18n.t('errors.unprocessable') }
        
        it 'operation result failed' do
          expect(result).to be_failure
          expect(result_errors[:base]).to eq(unprocessable_request_error)
        end
      end
    end
  end
end
