# frozen_string_literal: true

module Api::V1::Project::Operation
  class Update < ApplicationOperation
    step :set_project
    fail Macro::Semantic(failure: :not_found), fail_fast: true
    step Contract::Build(constant: Api::V1::Project::Contract::Save)
    step Contract::Validate(key: :project)
    step Contract::Persist()
    fail Macro::ContractErrors(error: I18n.t('errors.unprocessable'))
    pass :set_serializer
    pass Macro::Semantic(success: :ok)

    def set_project(ctx, params:, current_user:, **)
      ctx[:model] = current_user.projects.find_by(id: params[:id])
    end

    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::Project::Serializer::Save.new(model)
    end
  end
end
