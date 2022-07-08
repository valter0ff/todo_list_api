# frozen_string_literal: true

module Api::V1::User::Operation
  class Create < ApplicationOperation
    step Model(User, :new)
    step Contract::Build(constant: User::Contract::Create)
    step Contract::Validate(key: :user)
    step Contract::Persist()
  end
end
