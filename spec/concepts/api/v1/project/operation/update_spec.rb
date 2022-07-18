# frozen_string_literal: true

RSpec.describe Api::V1::Project::Operation::Update do
  let(:result) { described_class.call(params: params, current_user: user) }
  let(:user) { create(:user) }
  let(:project) { create(:project, title: title, user: user) }
  let(:title) { FFaker::Name.unique.name }

  describe '.call' do
    context 'when params are valid' do
      let(:params) { { id: project.id, project: { title: new_title } } }
      let(:new_title) { FFaker::Name.unique.name }

      it 'operation result successfull' do
        expect(result).to be_success
        expect(result[:semantic_success]).to eq(:ok)
        expect(result[:model]).to be_persisted
      end

      it 'updates project title' do
        expect { result }.to change { project.reload.title }.from(title).to(new_title)
      end
    end

    context 'when project id is invalid' do
      let(:params) { { id: rand(2..100), project: attributes_for(:project) } }

      it 'operation result failed' do
        expect(result).to be_failure
      end
    end

    context 'when project title is not unique' do
      let(:another_project) { create(:project, user: user) }
      let(:params) { { id: project.id, project: { title: another_project.title } } }
      let(:result_errors) { result['contract.default'].errors.messages }
      let(:unique_title_error) { I18n.t('errors.rules.project.rules.title.unique_title?') }

      it 'operation result failed' do
        expect(result).to be_failure
      end

      it 'assigns errors to result errors hash' do
        expect(result_errors).not_to be_empty
        expect(result_errors[:title].first).to eq(unique_title_error)
      end
    end

    context 'when params hasn`t key `project`' do
      let(:params) { { id: project.id, title: project.title } }
      let(:result_errors) { result['contract.default'].errors.messages }
      let(:unprocessable_request_error) { I18n.t('errors.unprocessable') }

      it 'operation result failed' do
        expect(result).to be_failure
        expect(result_errors[:base]).to eq(unprocessable_request_error)
      end
    end
  end
end
