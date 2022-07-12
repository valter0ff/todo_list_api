# frozen_string_literal: true

module Api::V1::User::Operation
  class Create < ApplicationOperation
    step Model(User, :new)
    step Contract::Build(constant: Api::V1::User::Contract::Create)
    step Contract::Validate(key: :user)
    step Contract::Persist()
    pass :set_serializer
    pass :set_semantic

    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::User::Serializer::Create.new(model)
    end

    def set_semantic(ctx, **)
      ctx[:semantic_success] = :created
    end
  end
end
