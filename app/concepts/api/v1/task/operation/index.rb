# frozen_string_literal: true

module Api::V1::Task::Operation
  class Index < ApplicationOperation
    step :find_project
    fail Macro::Semantic(failure: :not_found)
    step :assign_tasks
    pass :set_serializer
    pass Macro::Semantic(success: :ok)

    def find_project(ctx, current_user:, params:, **)
      ctx[:project] = current_user.projects.includes(:tasks).find_by(id: params[:project_id])
    end

    def assign_tasks(ctx, project:, **)
      ctx[:model_items] = project.tasks.order(:created_at)
    end

    def set_serializer(ctx, model_items:, **)
      ctx[:serializer] = Api::V1::Task::Serializer::Show.new(model_items, is_collection: true)
    end
  end
end
