# frozen_string_literal: true

module Api::V1::User::Contract
  class Create < ApplicationContract
    property :username
    property :password
    property :password_confirmation

    validation :default do
      configure { config.namespace = :user }

      required(:username).filled(:str?)
      required(:password).filled(:str?)
    end

    validation :size_format, if: :default do
      configure { config.namespace = :user }

      required(:username).value(size?: Constants::User::USER_NAME_SIZE)
      required(:password).value(size?: Constants::User::PASSWORD_SIZE, format?: Constants::User::PASSWORD_FORMAT)
    end

    validation :confirm, if: :size_format do
      configure { config.namespace = :user }

      required(:password).filled(:str?).confirmation
    end

    validation :uniqueness, if: :confirm do
      configure do
        config.namespace = :user

        def unique_username?(value)
          User.where(username: value).empty?
        end
      end

      required(:username).value(unique_username?: :username)
    end
  end
end
