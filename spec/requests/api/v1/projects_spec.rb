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

      response '422', 'Project title already exists' do
        let(:user) { create(:user) }
        let!(:project) { create(:project, user: user) }
        let(:'Authorization') { create_token(user: user) }
        let(:params) { { project: { title: project.title } } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/projects/errors')
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

  path '/api/v1/projects/{id}' do
    put 'Update project' do
      tags 'Project'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :id, in: :path, schema: { type: :integer, example: rand(1..100) }
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[project],
        properties: {
          title: { type: :string, example: FFaker::Lorem.word }
        }
      }

      response '200', 'Project is updated' do
        let(:user) { create(:user) }
        let(:project) { create(:project, user: user) }
        let(:id) { project.id }
        let(:'Authorization') { create_token(user: user) }
        let(:params) { { project: { title: FFaker::Name.unique.name } } }

        run_test! do
          expect(response).to be_ok
          expect(response).to match_json_schema('api/v1/projects/save')
        end
      end

      response '404', 'Invalid id' do
        let(:user) { create(:user) }
        let(:id) { rand(100) }
        let(:'Authorization') { create_token(user: user) }
        let(:params) { { project: { title: nil } } }

        run_test! do
          expect(response).to be_not_found
        end
      end

      response '422', 'Project title already exists' do
        let(:user) { create(:user) }
        let(:project) { create(:project, user: user) }
        let(:another_project) { create(:project, user: user) }
        let(:id) { project.id }
        let(:'Authorization') { create_token(user: user) }
        let(:params) { { project: { title: another_project.title } } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/projects/errors')
        end
      end

      response '422', 'Project title already exists' do
        let(:user) { create(:user) }
        let!(:project) { create(:project, user: user) }
        let(:'Authorization') { create_token(user: user) }
        let(:params) { { project: { title: project.title } } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/projects/errors')
        end
      end

      response '401', 'Invalid token' do
        let(:'Authorization') { nil }
        let(:id) { rand(100) }
        let(:params) { { project: { title: FFaker::Lorem.word } } }

        run_test! do
          expect(response).to be_unauthorized
        end
      end
    end
  end

  path '/api/v1/projects/{id}' do
    delete 'Destroy project' do
      tags 'Project'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :id, in: :path, schema: { type: :integer, example: rand(1..100) }

      response '204', 'Project is destroyed' do
        let(:user) { create(:user) }
        let(:project) { create(:project, user: user) }
        let(:id) { project.id }
        let(:'Authorization') { create_token(user: user) }

        run_test! do
          expect(response).to be_no_content
        end
      end

      response '404', 'Invalid id' do
        let(:user) { create(:user) }
        let(:id) { rand(100) }
        let(:'Authorization') { create_token(user: user) }
        let(:params) { { project: { title: nil } } }

        run_test! do
          expect(response).to be_not_found
        end
      end

      response '401', 'Invalid token' do
        let(:id) { rand(100) }
        let(:'Authorization') { nil }

        run_test! do
          expect(response).to be_unauthorized
        end
      end
    end
  end
end
