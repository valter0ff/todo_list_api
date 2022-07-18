# frozen_string_literal: true

module Api::V1::CurrentUser::Operation
  class Show < ApplicationOperation
    step :set_model
    fail Macro::Semantic(failure: :not_found)
    step :serializer
    pass Macro::Semantic(success: :ok)

    def set_model(ctx, current_user:, **)
      ctx[:model] = current_user
    end

    def serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::User::Serializer::Create.new(model)
    end
  end
end
