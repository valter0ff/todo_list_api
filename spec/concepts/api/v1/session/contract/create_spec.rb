# frozen_string_literal: true

RSpec.describe Api::V1::Session::Contract::Create do
  let(:contract) { define_contract_by_schema(described_class) }

  describe '.call' do
    before { contract.call(params) }

    context 'when params are valid' do
      let(:params) { { username: FFaker::Lorem.word, password: FFaker::Lorem.word } }

      it 'contract does not have errors' do
        expect(contract.errors).to be_empty
      end
    end

    context 'when params are invalid' do
      let(:params) { { username: '', password: '' } }
      let(:errors_path) { %w[errors rules user rules] }
      let(:username_blank_error) { I18n.t('username.filled?', scope: errors_path) }
      let(:password_blank_error) { I18n.t('password.filled?', scope: errors_path) }

      it 'returns errors' do
        expect(contract.errors.messages[:username].first).to eq(username_blank_error)
        expect(contract.errors.messages[:password].first).to eq(password_blank_error)
      end
    end
  end
end
