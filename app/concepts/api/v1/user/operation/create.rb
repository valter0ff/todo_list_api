# frozen_string_literal: true

module Api::V1::User::Operation
  class Create < ApplicationOperation
    step :set_model
    step Contract::Build(constant: Api::V1::User::Contract::Create)
    step Contract::Validate(key: :user)
    step Contract::Persist()
    pass :set_serializer
    pass :set_semantic

    def set_model(ctx, params:, **)
      username = params[:username]
      password = params[:password]
      password_confirmation =  params[:password_confirmation]
      ctx[:model] = User.new(username: username, password: password, password_confirmation: password_confirmation)
    end

    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::User::Serializer::Create.new(model)
    end

    def set_semantic(ctx, **)
      ctx[:semantic_success] == :created
    end
  end
end
