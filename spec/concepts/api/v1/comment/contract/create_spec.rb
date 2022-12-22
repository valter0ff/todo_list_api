# frozen_string_literal: true

RSpec.describe Api::V1::Comment::Contract::Create do
  let(:contract) { described_class.new(Comment.new) }
  let(:params) { { body: body, image: image } }
  let(:body) { FFaker::Name.unique.name }
  let(:image) { Rack::Test::UploadedFile.new(*file_params) }
  let(:file_params) { ['spec/fixtures/images/valid_image.jpg', 'image/jpeg'] }

  before { contract.validate(params) }

  describe 'attributes validations' do
    describe 'succes' do
      context 'when params are valid' do
        it 'contract does not have errors' do
          expect(contract.errors).to be_empty
        end
      end
    end

    describe 'failure' do
      let(:invalid_image_error) { I18n.t('errors.rules.comment.rules.image.valid_image?') }

      context 'when comment`s body is blank' do
        let(:body) { '' }
        let(:body_blank_error) { I18n.t('errors.filled?') }

        it 'returns errors' do
          expect(contract.errors.messages[:body].first).to eq(body_blank_error)
        end
      end

      context 'when comment`s image has invalid format' do
        let(:file_params) { ['spec/fixtures/images/invalid_format_image.gif', 'image/gif'] }

        it 'returns errors' do
          expect(contract.errors.messages[:image].first).to eq(invalid_image_error)
        end
      end

      context 'when comment`s image is too big' do
        let(:file_params) { ['spec/fixtures/images/too_big_image.jpg', 'image/jpeg'] }

        it 'returns errors' do
          expect(contract.errors.messages[:image].first).to eq(invalid_image_error)
        end
      end
    end
  end
end
