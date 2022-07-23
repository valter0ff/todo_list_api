# frozen_string_literal: true

RSpec.describe Api::V1::Task::Contract::Update do
  let(:contract) { described_class.new(task) }
  let(:task) { create(:task) }
  let(:params) { { name: name, position: position } }
  let(:name) { FFaker::Name.unique.name }
  let(:position) { rand(2..100) }

  describe 'attributes validations' do
    before { contract.validate(params) }

    context 'when params are valid' do
      it 'contract does not have errors' do
        expect(contract.errors).to be_empty
      end
    end

    context 'when name is blank' do
      let(:name) { '' }
      let(:name_blank_error) { I18n.t('errors.rules.task.rules.name.filled?') }

      it 'returns errors' do
        expect(contract.errors.messages[:name].first).to eq(name_blank_error)
      end
    end

    context 'when position is blank' do
      let(:position) { '' }
      let(:position_blank_error) { I18n.t('errors.filled?') }

      it 'returns errors' do
        expect(contract.errors.messages[:position].first).to eq(position_blank_error)
      end
    end

    context 'when position is not integer' do
      let(:position) { FFaker::Lorem.word }
      let(:position_type_error) { I18n.t('errors.int?') }

      it 'returns errors' do
        expect(contract.errors.messages[:position].first).to eq(position_type_error)
      end
    end

    context 'when task status is `done`' do
      let(:task) { create(:task, :done) }
      let(:task_complete_error) { I18n.t('errors.rules.task.rules.status.in_progress?') }

      it 'returns errors' do
        expect(contract.errors.messages[:status].first).to eq(task_complete_error)
      end
    end
  end
end
