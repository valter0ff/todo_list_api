# frozen_string_literal: true

module Api::V1::CurrentUser::Operation
  class Show < ApplicationOperation
    step :set_model
    step :serializer
    pass Macro::Semantic(success: :ok)

    def set_model(ctx, **)
      ctx[:model] = current_user
    end

    def serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::User::Serializer::Create.new(model)
    end
  end
end
