# frozen_string_literal: true

RSpec.describe Api::V1::Task::Contract::Create do
  let(:contract) { described_class.new(Task.new) }

  describe 'attributes validations' do
    before { contract.validate(params) }

    context 'when params are valid' do
      let(:params) { attributes_for(:task) }

      it 'contract does not have errors' do
        expect(contract.errors).to be_empty
      end
    end

    context 'when name is blank' do
      let(:params) { { name: '' } }
      let(:name_blank_error) { I18n.t('errors.rules.task.rules.name.filled?') }

      it 'returns errors' do
        expect(contract.errors.messages[:name].first).to eq(name_blank_error)
      end
    end
  end
end
