# frozen_string_literal: true

module Api::V1::Project::Operation
  class Create < ApplicationOperation
    step :build_project
    step Contract::Build(constant: Api::V1::Project::Contract::Save)
    step Contract::Validate(key: :project)
    step Contract::Persist()
    fail Macro::ContractErrors(error: I18n.t('errors.unprocessable'))
    pass :set_serializer
    pass Macro::Semantic(success: :created)

    def build_project(ctx, current_user:, **)
      ctx[:model] = current_user.projects.build
    end
    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::Project::Serializer::Save.new(model)
    end
  end
end
