# frozen_string_literal: true

RSpec.describe Api::V1::Project::Operation::Destroy do
  let(:result) { described_class.call(params: params, current_user: user) }
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  describe '.call' do
    context 'when params are valid' do
      let(:params) { { id: project.id } }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:destroyed)
      end

      it 'deletes project from database' do
        expect { result }.to change(Project, :count).by(-1)
      end
    end

    context 'when project id is invalid' do
      let(:params) { { id: rand(2..100) } }

      it 'operation result failed' do
        expect(result).to be_failure
        expect(result[:semantic_failure]).to eq(:not_found)
      end

      it 'doesn`t delete project from database' do
        expect { result }.not_to change(Project, :count)
      end
    end
  end
end
