# frozen_string_literal: true

module Api::V1::User::Operation
  class Create < ApplicationOperation
    step Model(User, :new)
    step Contract::Build(constant: Api::V1::User::Contract::Create)
    step Contract::Validate(key: :user)
    step Contract::Persist()
    fail Macro::ContractErrors(error: I18n.t('errors.unprocessable'))
    pass :set_serializer
    pass Macro::Semantic(success: :created)

    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::Lib::UserSerializer::Show.new(model)
    end
  end
end
