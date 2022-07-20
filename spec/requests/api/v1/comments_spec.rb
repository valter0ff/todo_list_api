# frozen_string_literal: true

RSpec.describe 'api/v1/comment', type: :request do
  after do |example|
    if response.body.present?
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end
  end

  path '/api/v1/tasks/{task_id}/comments' do
    get 'Task comments index' do
      tags 'Comment'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :task_id, in: :path, schema: { type: :integer, example: rand(1..100) }

      response '200', 'Task comments returned' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project) { create(:project, user: user) }
        let(:task) { create(:task, :with_comments, project: project) }
        let(:task_id) { task.id }

        run_test! do
          expect(response).to be_ok
          expect(response).to match_json_schema('api/v1/comments/index')
        end
      end

      response '404', 'Invalid task id' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:task_id) { rand(2..100) }

        run_test! do
          expect(response).to be_not_found
        end
      end
    end
  end

  path '/api/v1/tasks/{task_id}/comments' do
    post 'Create comment' do
      tags 'Comment'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :task_id, in: :path, schema: { type: :integer, example: rand(1..100) }
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[comment],
        properties: {
          body: { type: :string, example: FFaker::Name.unique.name }
        }
      }

      response '201', 'Comment is created' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project) { create(:project, :with_tasks, user: user) }
        let(:task_id) { project.tasks.first.id }
        let(:params) { { comment: { body: FFaker::Name.unique.name } } }

        run_test! do
          expect(response).to be_created
          expect(response).to match_json_schema('api/v1/comments/create')
        end
      end

      response '422', 'Invalid comment body' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:project) { create(:project, :with_tasks, user: user) }
        let(:task_id) { project.tasks.first.id }
        let(:params) { { comment: { body: nil } } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/comments/errors')
        end
      end

      response '404', 'Invalid task id' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }
        let(:task_id) { rand(1..100) }
        let(:params) { { comment: { body: FFaker::Lorem.word } } }

        run_test! do
          expect(response).to be_not_found
        end
      end

      response '401', 'Invalid token' do
        let(:'Authorization') { nil }
        let(:task_id) { rand(1..100) }
        let(:params) { { comment: { body: FFaker::Lorem.word } } }

        run_test! do
          expect(response).to be_unauthorized
        end
      end
    end
  end
end
