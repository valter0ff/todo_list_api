# frozen_string_literal: true

module Api::V1::Task::Operation
  class Update < ApplicationOperation
    step :set_model
    fail Macro::Semantic(failure: :not_found), fail_fast: true
    step Contract::Build(constant: Api::V1::Task::Contract::Update)
    step Contract::Validate(key: :task)
    step Contract::Persist()
    fail Macro::ContractErrors(error: I18n.t('errors.unprocessable'))
    pass :set_serializer
    pass Macro::Semantic(success: :ok)

    def set_model(ctx, current_user:, params:, **)
      ctx[:model] = current_user.tasks.find_by(id: params[:id])
    end

    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::Task::Serializer::Show.new(model)
    end
  end
end
