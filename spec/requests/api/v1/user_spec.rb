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
      parameter name: :username, in: :body, schema: {
        type: :string, example: FFaker::Lorem.word
      }
      parameter name: :password, in: :body, schema: {
        type: :string, example: FFaker::Internet.password
      }
      parameter name: :password_confirmation, in: :body, schema: {
        type: :string, example: FFaker::Internet.password
      }

      response '201', 'Created' do
        let(:username) { FFaker::Lorem.word }
        let(:password) { 'qwerty12' }
        let(:password_confirmation) { 'qwerty12' }

        run_test! do
          expect(response).to match_json_schema('api/v1/user/create')
        end
      end
    end
  end
end
