# frozen_string_literal: true

RSpec.describe 'api/v1/task', type: :request do
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
  let(:project) { create(:project, :with_tasks, user: user) }
  let(:project_id) { project.id }

  path '/api/v1/projects/{project_id}/tasks' do
    get 'Project tasks index' do
      tags 'Task'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :project_id, in: :path, schema: { type: :integer, example: rand(1..100) }

      response '200', 'Project tasks returned' do
        run_test! do
          expect(response).to be_ok
          expect(response).to match_json_schema('api/v1/tasks/index')
        end
      end

      response '404', 'Invalid project id' do
        let(:project_id) { rand(2..100) }

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

  path '/api/v1/projects/{project_id}/tasks' do
    let(:params) { { task: { name: FFaker::Lorem.unique.word } } }

    post 'Create task' do
      tags 'Task'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :project_id, in: :path, schema: { type: :integer, example: rand(1..100) }
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[task],
        properties: {
          name: { type: :string, example: FFaker::Lorem.word }
        }
      }

      response '201', 'Task is created' do
        run_test! do
          expect(response).to be_created
          expect(response).to match_json_schema('api/v1/tasks/create')
        end
      end

      response '422', 'Invalid task name' do
        let(:params) { { task: { name: nil } } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/tasks/errors')
        end
      end

      response '404', 'Invalid project id' do
        let(:project_id) { rand(1..100) }

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
