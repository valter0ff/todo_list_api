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

  path '/api/v1/projects/{project_id}/tasks' do
    get 'Project tasks index' do
      tags 'Task'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :project_id, in: :path, schema: { type: :integer, example: rand(1..100) }

      response '200', 'Project tasks returned' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project) { create(:project, :with_tasks, user: user) }
        let(:project_id) { project.id }

        run_test! do
          expect(response).to be_ok
          expect(response).to match_json_schema('api/v1/tasks/index')
        end
      end

      response '404', 'Invalid project id' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project_id) { rand(2..100) }

        run_test! do
          expect(response).to be_not_found
        end
      end
    end
  end

  path '/api/v1/projects/{project_id}/tasks' do
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
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project) { create(:project, user: user) }
        let(:project_id) { project.id }
        let(:params) { { task: { name: FFaker::Name.unique.name } } }

        run_test! do
          expect(response).to be_created
          expect(response).to match_json_schema('api/v1/tasks/create')
        end
      end

      response '422', 'Invalid task name' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project) { create(:project, user: user) }
        let(:project_id) { project.id }
        let(:params) { { task: { name: nil } } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/tasks/errors')
        end
      end

      response '404', 'Invalid project id' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project_id) { rand(1..100) }
        let(:params) { { task: { name: FFaker::Lorem.word } } }

        run_test! do
          expect(response).to be_not_found
        end
      end

      response '401', 'Invalid token' do
        let(:'Authorization') { nil }
        let(:project_id) { rand(1..100) }
        let(:params) { { task: { name: FFaker::Lorem.word } } }

        run_test! do
          expect(response).to be_unauthorized
        end
      end
    end
  end

  path '/api/v1/tasks/{id}/is_done' do
    put 'Update task status' do
      tags 'Task'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :id, in: :path, schema: { type: :integer, example: rand(1..100) }

      response '200', 'Task status changed' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project) { create(:project, :with_tasks, user: user) }
        let(:id) { project.tasks.first.id }

        run_test! do
          expect(response).to be_ok
          expect(response).to match_json_schema('api/v1/tasks/is_done')
        end
      end

      response '404', 'Invalid task id' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let!(:project) { create(:project, :with_tasks, user: user) }
        let(:id) { rand(1..100) }

        run_test! do
          expect(response).to be_not_found
        end
      end
    end
  end

  path '/api/v1/tasks/{id}' do
    put 'Update task' do
      tags 'Task'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :id, in: :path, schema: { type: :integer, example: rand(1..100) }
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[task],
        properties: {
          name: { type: :string, example: FFaker::Lorem.word }
        }
      }

      response '200', 'Task updated' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project) { create(:project, :with_tasks, user: user) }
        let(:id) { project.tasks.first.id }
        let(:params) { { task: { name: FFaker::Name.unique.name } } }

        run_test! do
          expect(response).to be_ok
          expect(response).to match_json_schema('api/v1/tasks/create')
        end
      end

      response '404', 'Invalid task id' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let!(:project) { create(:project, :with_tasks, user: user) }
        let(:id) { rand(1..100) }
        let(:params) { { task: { name: FFaker::Name.unique.name } } }

        run_test! do
          expect(response).to be_not_found
        end
      end

      response '422', 'Task already completed' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project) { create(:project, user: user) }
        let(:task) { create(:task, :is_done, project: project) }
        let(:id) { task.id }
        let(:params) { { task: { name: FFaker::Name.unique.name } } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/tasks/task_complete_error')
        end
      end
    end
  end

  path '/api/v1/tasks/{id}/set_deadline' do
    put 'Set task deadline' do
      tags 'Task'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :id, in: :path, schema: { type: :integer, example: rand(1..100) }
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[task],
        properties: {
          deadline: { type: :string, example: DateTime.now.to_s }
        }
      }

      response '200', 'Task deadline updated' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project) { create(:project, :with_tasks, user: user) }
        let(:id) { project.tasks.first.id }
        let(:params) { { task: { deadline: DateTime.now.next_week.to_s } } }

        run_test! do
          expect(response).to be_ok
          expect(response).to match_json_schema('api/v1/tasks/set_deadline')
        end
      end

      response '404', 'Invalid task id' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let!(:project) { create(:project, :with_tasks, user: user) }
        let(:id) { rand(1..100) }
        let(:params) { { task: { deadline: DateTime.now.to_s } } }

        run_test! do
          expect(response).to be_not_found
        end
      end

      response '422', 'Task already completed' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project) { create(:project, user: user) }
        let(:task) { create(:task, :is_done, project: project) }
        let(:id) { task.id }
        let(:params) { { task: { deadline: DateTime.now.to_s } } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/tasks/task_complete_error')
        end
      end

      response '422', 'Blank deadline parameter' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project) { create(:project, :with_tasks, user: user) }
        let(:id) { project.tasks.first.id }
        let(:params) { { task: { deadline: '' } } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/tasks/deadline_error')
        end
      end
    end
  end
end
