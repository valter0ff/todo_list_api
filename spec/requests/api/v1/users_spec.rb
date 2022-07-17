# frozen_string_literal: true

RSpec.describe 'api/v1/user', type: :request do
  after do |example|
    if response.body.present?
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end
  end

  path '/api/v1/user' do
    post 'Create user' do
      tags 'User'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[user],
        properties: {
          user: {
            type: :object,
            required: %w[username password password_confirmation],
            properties: {
              username: { type: :string, example: "#{FFaker::Internet.user_name}xx" },
              password: { type: :string, example: 'qwerty12' },
              password_confirmation: { type: :string, example: 'qwerty12' }
            }
          }
        }
      }

      response '201', 'Created' do
        let(:params) { { user: attributes_for(:user) } }

        run_test! do
          expect(response).to be_created
          expect(response).to match_json_schema('api/v1/users/create')
        end
      end

      response '422', 'Invalid params' do
        let(:params) { { user: {} } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/users/errors')
        end
      end

      response '422', 'User name already exists' do
        let!(:user) { create(:user) }
        let(:params) { { user: attributes_for(:user, username: user.username) } }

        run_test! do
          expect(response).to be_unprocessable
          # expect(response).to match_json_schema('api/v1/users/errors')
        end
      end
    end
  end
end
