# frozen_string_literal: true

module Api::V1::Task::Operation
  class Destroy < ApplicationOperation
    step :set_model
    fail Macro::Semantic(failure: :not_found)
    pass :destroy_task
    pass Macro::Semantic(success: :destroyed)

    def set_model(ctx, current_user:, params:, **)
      ctx[:model] = current_user.tasks.find_by(id: params[:id])
    end

    def destroy_task(_ctx, model:, **)
      model.destroy
    end
  end
end
