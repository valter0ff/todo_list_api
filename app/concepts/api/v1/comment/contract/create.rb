# frozen_string_literal: true

module Api::V1::Comment::Contract
  class Create < ApplicationContract
    property :body

    validation :default do
      configure { config.namespace = :comment }

      required(:body).filled(:str?)
    end
  end
end
