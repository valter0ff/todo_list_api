# frozen_string_literal: true

module Api::V1::Task::Operation
  class Create < ApplicationOperation
    step :find_project
    fail Macro::Semantic(failure: :not_found), fail_fast: true
    step :set_model
    step Contract::Build(constant: Api::V1::Task::Contract::Create)
    step Contract::Validate(key: :task)
    step Contract::Persist()
    fail Macro::ContractErrors(error: I18n.t('errors.unprocessable'))
    pass :set_serializer
    pass Macro::Semantic(success: :created)

    def find_project(ctx, current_user:, params:, **)
      ctx[:project] = current_user.projects.find_by(id: params[:project_id])
    end

    def set_model(ctx, project:, **)
      ctx[:model] = project.tasks.build
    end

    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::Task::Serializer::Show.new(model)
    end
  end
end
