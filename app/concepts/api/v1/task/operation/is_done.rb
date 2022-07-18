# frozen_string_literal: true

module Api::V1::Task::Operation
  class IsDone < ApplicationOperation
    step :set_model
    fail Macro::Semantic(failure: :not_found)
    pass :change_model_status
    pass :set_serializer
    pass Macro::Semantic(success: :ok)

    def set_model(ctx, current_user:, params:, **)
      ctx[:model] = current_user.tasks.find_by(id: params[:id])
    end

    def change_model_status(_ctx, model:, **)
      model.is_done!
    end

    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::Task::Serializer::Show.new(model)
    end
  end
end
