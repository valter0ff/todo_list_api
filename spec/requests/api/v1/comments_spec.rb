# frozen_string_literal: true

RSpec.describe 'api/v1/comment', type: :request do
  after do |example|
    if response.body.present?
      example.metadata[:response][:content] = {
        'application/json' => {
          examples: {
            example.metadata[:example_group][:description] => {
              value: JSON.parse(response.body, symbolize_names: true)
            }
          }
        }
      }
    end
  end

  let(:'Authorization') { create_token(user: task.project.user) }

  path '/api/v1/tasks/{task_id}/comments' do
    get 'Task comments index' do
      tags 'Comment'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :task_id, in: :path, schema: { type: :integer, example: rand(1..100) }

      let(:task) { create(:task, :with_comments) }
      let(:task_id) { task.id }

      response '200', 'Task comments returned' do
        run_test! do
          expect(response).to be_ok
          expect(response).to match_json_schema('api/v1/comments/index')
        end
      end

      response '404', 'Invalid task id' do
        let(:task_id) { rand(2..100) }

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

      let(:task) { create(:task) }
      let(:task_id) { task.id }
      let(:params) { { comment: { body: body } } }
      let(:body) { FFaker::Name.unique.name }

      response '201', 'Comment is created' do
        run_test! do
          expect(response).to be_created
          expect(response).to match_json_schema('api/v1/comments/create')
        end
      end

      response '422', 'Invalid comment body' do
        let(:body) { nil }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/comments/errors')
        end
      end

      response '404', 'Invalid task id' do
        let(:task_id) { rand(3..100) }

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

  path '/api/v1/comments/{id}' do
    delete 'Delete comment' do
      tags 'Comment'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'
      parameter name: :id, in: :path, schema: { type: :integer, example: rand(1..100) }

      let(:task) { create(:task) }
      let(:comment) { create(:comment, task: task) }
      let(:id) { comment.id }

      response '204', 'Comment destroyed' do
        run_test! do
          expect(response).to be_no_content
        end
      end

      response '404', 'Invalid comment id' do
        let(:id) { rand(1..100) }

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
