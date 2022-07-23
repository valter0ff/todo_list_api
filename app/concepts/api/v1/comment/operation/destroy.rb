# frozen_string_literal: true

module Api::V1::Comment::Operation
  class Destroy < ApplicationOperation
    step :set_model
    fail Macro::Semantic(failure: :not_found)
    step :check_task_existence
    fail Macro::Semantic(failure: :not_found)
    pass :destroy_comment
    pass Macro::Semantic(success: :destroyed)

    def set_model(ctx, params:, **)
      ctx[:model] = Comment.find_by(id: params[:id])
    end

    def check_task_existence(_ctx, model:, current_user:, **)
      current_user.tasks.exists?(id: model.task.id)
    end

    def destroy_comment(_ctx, model:, **)
      model.destroy
    end
  end
end
