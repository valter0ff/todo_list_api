# frozen_string_literal: true

RSpec.describe 'api/v1/project', type: :request do
  after do |example|
    if response.body.present?
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end
  end
  path '/api/v1/projects' do
    post 'Create project' do
      tags 'Project'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[project],
        properties: {
          title: { type: :string, example: FFaker::Lorem.word }
        }
      }

      response '201', 'Project is created' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:params) { { project: { title: FFaker::Lorem.word } } }

        run_test! do
          expect(response).to be_created
          expect(response).to match_json_schema('api/v1/projects/save')
        end
      end

      response '422', 'Invalid parameters' do
        context 'when title is invalid' do
          let(:user) { create(:user) }
          let(:'Authorization') { create_token(user: user) }
          let(:params) { { project: { title: nil } } }

          run_test! do
            expect(response).to be_unprocessable
            expect(response).to match_json_schema('api/v1/projects/errors')
          end
        end

        context 'when project with provided title already exists' do
          let(:user) { create(:user) }
          let!(:project) { create(:project, user: user) }
          let(:'Authorization') { create_token(user: user) }
          let(:params) { { project: { title: project.title } } }

          run_test! do
            expect(response).to be_unprocessable
            expect(response).to match_json_schema('api/v1/projects/errors')
          end
        end
      end

      response '401', 'Invalid token' do
        let(:'Authorization') { nil }
        let(:params) { { project: { title: FFaker::Lorem.word } } }

        run_test! do
          expect(response).to be_unauthorized
        end
      end
    end
  end
end
