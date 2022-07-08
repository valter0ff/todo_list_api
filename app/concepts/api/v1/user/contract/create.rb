# frozen_string_literal: true

module Api::V1::User::Contract
  class Create < ApplicationContract
    property :username
    property :password
    property :password_confirmation

    validation :default do
      required(:username).filled(:str?)
      required(:password).filled(:str?)
    end

    validation :size_format, if: :default do
      required(:username).value(size?: Constants::User::USER_NAME_SIZE)
      required(:password).value(format?: Constants::User::PASSWORD_FORMAT)
    end

    validation :confirm, if: :size_format do
      required(:password).value.confirmation
    end
  end
end
