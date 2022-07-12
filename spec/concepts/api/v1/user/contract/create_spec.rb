# frozen_string_literal: true

RSpec.describe Api::V1::User::Contract::Create do
  let(:contract) { described_class.new(User.new) }

  describe '#validate' do
    let(:errors_path) { %w[errors rules user rules] }

    context 'when params are valid' do
      let(:params) { attributes_for(:user) }

      it 'returns true' do
        expect(contract.validate(params)).to be true
      end
    end

    context 'when params are invalid' do
      let(:params) { {} }

      it 'returns false' do
        expect(contract.validate(params)).to be false
      end
    end

    describe 'attributes validations' do
      before { contract.validate(params) }

      context 'when username and password are blank' do
        let(:params) { attributes_for(:user, username: '', password: '') }
        let(:username_blank_error) { I18n.t('username.filled?', scope: errors_path) }
        let(:password_blank_error) { I18n.t('password.filled?', scope: errors_path) }

        it 'returns errors' do
          expect(contract.errors.messages[:username].first).to eq(username_blank_error)
          expect(contract.errors.messages[:password].first).to eq(password_blank_error)
        end
      end

      context 'when username and password are too short' do
        let(:params) { attributes_for(:user, username: 'ab', password: 'ab') }
        let(:username_min_size_error) { I18n.t('username.min_size?', scope: errors_path) }
        let(:password_size_error) { I18n.t('password.size?', scope: errors_path) }

        it 'returns errors' do
          expect(contract.errors.messages[:username].first).to eq(username_min_size_error)
          expect(contract.errors.messages[:password].first).to eq(password_size_error)
        end
      end

      context 'when username and password are too long' do
        let(:long_username) { 'a' * (Constants::User::USERNAME_MAX_SIZE + 1) }
        let(:long_password) { 'a' * (Constants::User::PASSWORD_SIZE + 1) }
        let(:params) { attributes_for(:user, username: long_username, password: long_password) }
        let(:username_max_size_error) { I18n.t('username.max_size?', scope: errors_path) }
        let(:password_size_error) { I18n.t('password.size?', scope: errors_path) }

        it 'returns errors' do
          expect(contract.errors.messages[:username].first).to eq(username_max_size_error)
          expect(contract.errors.messages[:password].first).to eq(password_size_error)
        end
      end

      context 'when password format is invalid' do
        let(:params) { attributes_for(:user, password: '123456_a') }
        let(:password_format_error) { I18n.t('password.format?', scope: errors_path) }

        it 'returns error' do
          expect(contract.errors.messages[:password].first).to eq(password_format_error)
        end
      end

      context 'when username is not unique' do
        let!(:user) { create(:user) }
        let(:params) { attributes_for(:user, username: user.username) }
        let(:username_unique_error) { I18n.t('username.unique_username?', scope: errors_path) }

        it 'returns error' do
          expect(contract.errors.messages[:username].first).to eq(username_unique_error)
        end
      end

      context 'when password and confirm password fields does not match' do
        let(:params) { attributes_for(:user, password: 'qwerty12', password_confirmation: 'qwer') }
        let(:password_confirmation_error) { I18n.t('password_confirmation.eql?', scope: errors_path) }

        it 'returns error' do
          expect(contract.errors.messages[:password_confirmation].first).to eq(password_confirmation_error)
        end
      end
    end
  end
end
