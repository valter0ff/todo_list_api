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

  let(:user) { create(:user) }
  let(:'Authorization') { create_token(user: user) }

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

      let(:params) { { project: { title: title } } }
      let(:title) { FFaker::Lorem.word }

      response '201', 'Project is created' do
        run_test! do
          expect(response).to be_created
          expect(response).to match_json_schema('api/v1/projects/save')
        end
      end

      response '422', 'Invalid parameters' do
        context 'when title is invalid' do
          let(:title) { nil }

          run_test! do
            expect(response).to be_unprocessable
            expect(response).to match_json_schema('api/v1/projects/errors')
          end
        end

        context 'when project with provided title already exists' do
          let!(:project) { create(:project, user: user) }
          let(:title) { project.title }

          run_test! do
            expect(response).to be_unprocessable
            expect(response).to match_json_schema('api/v1/projects/errors')
          end
        end
      end

      response '401', 'Invalid token' do
        let(:'Authorization') { nil }

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

      let(:project) { create(:project, user: user) }
      let(:id) { project.id }
      let(:params) { { project: { title: title } } }
      let(:title) { FFaker::Name.unique.name }

      response '200', 'Project is updated' do
        run_test! do
          expect(response).to be_ok
          expect(response).to match_json_schema('api/v1/projects/save')
        end
      end

      response '404', 'Invalid project id' do
        let(:id) { rand(100) }

        run_test! do
          expect(response).to be_not_found
        end
      end

      response '422', 'Project title already exists' do
        let(:another_project) { create(:project, user: user) }
        let(:title) { another_project.title }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/projects/errors')
        end
      end

      response '401', 'Invalid token' do
        let(:'Authorization') { nil }

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

      let(:project) { create(:project, user: user) }
      let(:id) { project.id }

      response '204', 'Project is destroyed' do
        run_test! do
          expect(response).to be_no_content
        end
      end

      response '404', 'Invalid id' do
        let(:id) { rand(100) }

        run_test! do
          expect(response).to be_not_found
        end
      end

      response '401', 'Invalid token' do
        let(:'Authorization') { nil }

        run_test! do
          expect(response).to be_unauthorized
        end
      end
    end
  end
end
