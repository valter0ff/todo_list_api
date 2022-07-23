# frozen_string_literal: true

RSpec.describe Api::V1::Session::Operation::Destroy do
  let(:result) { described_class.call(params) }

  describe '.call' do
    context 'when token is valid' do
      let(:user) { create(:user) }
      let(:payload) { create_token(user: user) }
      let(:params) { { payload: JWTSessions::Token.decode(payload).first } }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:destroyed)
      end
    end
  end
end
