# frozen_string_literal: true

RSpec.describe Api::V1::Task::Contract::Update do
  let(:contract) { described_class.new(task) }

  describe 'attributes validations' do
    before { contract.validate(params) }

    context 'when params are valid' do
      let(:task) { create(:task) }
      let(:params) { attributes_for(:task, position: rand(1..100)) }

      it 'contract does not have errors' do
        expect(contract.errors).to be_empty
      end
    end

    context 'when name is blank' do
      let(:task) { create(:task) }
      let(:params) { { name: '' } }
      let(:name_blank_error) { I18n.t('errors.rules.task.rules.name.filled?') }

      it 'returns errors' do
        expect(contract.errors.messages[:name].first).to eq(name_blank_error)
      end
    end

    context 'when position is blank' do
      let(:task) { create(:task) }
      let(:params) { { name: FFaker::Name.name, position: '' } }
      let(:position_blank_error) { I18n.t('errors.filled?') }

      it 'returns errors' do
        expect(contract.errors.messages[:position].first).to eq(position_blank_error)
      end
    end

    context 'when position is not integer' do
      let(:task) { create(:task) }
      let(:params) { { name: FFaker::Name.name, position: FFaker::Lorem.word } }
      let(:position_type_error) { I18n.t('errors.int?') }

      it 'returns errors' do
        expect(contract.errors.messages[:position].first).to eq(position_type_error)
      end
    end

    context 'when task status `is_done`' do
      let(:task) { create(:task, :is_done) }
      let(:params) { attributes_for(:task) }
      let(:task_complete_error) { I18n.t('errors.rules.task.rules.status.is_done?') }

      it 'returns errors' do
        expect(contract.errors.messages[:status].first).to eq(task_complete_error)
      end
    end
  end
end
