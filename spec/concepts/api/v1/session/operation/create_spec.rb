# frozen_string_literal: true

RSpec.describe Api::V1::Session::Operation::Create do
  let(:result) { described_class.call(params: params) }

  describe '.call' do
    context 'when params are valid' do
      let(:user) { create(:user) }
      let(:params) { { username: user.username, password: user.password } }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:created)
      end
    end

    context 'when user doesn`t exist' do
      let(:params) { { username: FFaker::Lorem.word, password: FFaker::Lorem.word } }

      it 'operation result failed' do
        expect(result).to be_failure
        expect(result[:semantic_failure]).to eq(:not_found)
      end
    end

    context 'when password is invalid' do
      let(:user) { create(:user) }
      let(:params) { { username: user.username, password: FFaker::Lorem.word } }
      let(:result_errors) { result['contract.default'].errors.messages }
      let(:unauthorized_error) { I18n.t('errors.rules.session.unauthorized') }

      it 'operation result failed' do
        expect(result).to be_failure
        expect(result[:semantic_failure]).to eq(:unauthorized)
      end

      it 'assigns error to result errors hash' do
        expect(result_errors).not_to be_empty
        expect(result_errors[:base]).to eq(unauthorized_error)
      end
    end
  end
end
