# frozen_string_literal: true

RSpec.describe 'api/v1/sessions', type: :request do
  after do |example|
    if response.body.present?
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end
  end

  path '/api/v1/session' do
    post 'Create session' do
      tags 'Sessions'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        required: %w[username password],
        properties: {
          username: { type: :string, example: "#{FFaker::Internet.user_name}xx" },
          password: { type: :string, example: 'qwerty12' }
        }
      }

      response '201', 'Session is created' do
        let(:user) { create(:user) }
        let(:password) { user.password }
        let(:credentials) { { username: user.username, password: password } }

        run_test! do
          expect(response).to be_created
          expect(response).to match_json_schema('api/v1/sessions/create')
        end
      end

      response '404', 'Not found' do
        let(:credentials) { { username: FFaker::Internet.unique.user_name, password: FFaker::Lorem.word } }

        run_test! do
          expect(response).to be_not_found
        end
      end

      response '401', 'Invalid credentials' do
        let(:user) { create(:user) }
        let(:credentials) { { username: user.username, password: FFaker::Lorem.word } }

        run_test! do
          expect(response).to be_unauthorized
        end
      end

      response '422', 'Blank username and password' do
        let(:credentials) { { username: '', password: '' } }

        run_test! do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('api/v1/sessions/errors')
        end
      end
    end
  end

  path '/api/v1/session' do
    delete 'Destroys session' do
      tags 'Sessions'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :'Authorization', in: :header, type: :string, description: 'Access token'

      response '204', 'Session is destroyed' do
        let(:user) { create(:user) }
        let(:'Authorization') { create_token(user: user) }

        run_test! do
          expect(response).to be_no_content
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
