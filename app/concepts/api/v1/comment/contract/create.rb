# frozen_string_literal: true

module Api::V1::Comment::Contract
  class Create < ApplicationContract
    property :body
    property :image

    validation :default do
      configure do
        config.namespace = :comment

        def valid_image?(value)
          attacher = ImageUploader::Attacher.new
          attacher.assign(value)
          return false if attacher.errors.any?

          value.open
          true
        end
      end

      required(:body).filled(:str?)
      optional(:image).maybe(:valid_image?)
    end
  end
end
