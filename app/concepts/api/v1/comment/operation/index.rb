# frozen_string_literal: true

module Api::V1::Comment::Operation
  class Index < ApplicationOperation
    step :find_task
    fail Macro::Semantic(failure: :not_found)
    pass :assign_comments
    pass :set_serializer
    pass Macro::Semantic(success: :ok)

    def find_task(ctx, current_user:, params:, **)
      ctx[:task] = current_user.tasks.includes(:comments).find_by(id: params[:task_id])
    end

    def assign_comments(ctx, task:, **)
      ctx[:model_items] = task.comments.order(:created_at)
    end

    def set_serializer(ctx, model_items:, **)
      ctx[:serializer] = Api::V1::Comment::Serializer::Show.new(model_items, is_collection: true)
    end
  end
end
