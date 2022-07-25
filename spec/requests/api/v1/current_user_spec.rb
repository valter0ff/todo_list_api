# frozen_string_literal: true

RSpec.describe '/api/v1/current_user', type: :request do
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

  path '/api/v1/current_user' do
    get 'Show current user' do
      tags 'Current user'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: 'Access token'

      response '200', 'Current user is returned' do
        let(:user) { create(:user) }
        let(:Authorization) { create_token(user: user) }

        run_test! do
          expect(response).to be_ok
          expect(response).to match_json_schema('api/v1/users/create')
        end
      end

      response '401', 'Invalid token' do
        let(:Authorization) { nil }

        run_test! do
          expect(response).to be_unauthorized
        end
      end
    end
  end
end
