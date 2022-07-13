# frozen_string_literal: true

module Api::V1::Session::Contract
  Create = Dry::Validation.Schema do
    configure { config.namespace = :user }

    required(:username).filled(:str?)
    required(:password).filled(:str?)
  end
end
