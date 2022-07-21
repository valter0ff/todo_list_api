# frozen_string_literal: true

module Api::V1::Project::Operation
  class Destroy < ApplicationOperation
    step :set_project
    fail Macro::Semantic(failure: :not_found)
    step :destroy_project
    pass Macro::Semantic(success: :destroyed)

    def set_project(ctx, params:, current_user:, **)
      ctx[:model] = current_user.projects.find_by(id: params[:id])
    end

    def destroy_project(_ctx, model:, **)
      model.destroy
    end
  end
end
