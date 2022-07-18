# frozen_string_literal: true

RSpec.describe Api::V1::CurrentUser::Operation::Show do
  let(:result) { described_class.call(current_user: user) }

  describe '.call' do
    context 'when user exists' do
      let(:user) { create(:user) }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:ok)
      end
    end

    context 'when user doesn`t exist' do
      let(:user) { nil }

      it 'operation result failed' do
        expect(result).to be_failure
        expect(result[:semantic_failure]).to eq(:not_found)
      end
    end
  end
end
