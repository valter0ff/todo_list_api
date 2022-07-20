# frozen_string_literal: true

module Api::V1::Comment::Operation
  class Create < ApplicationOperation
    step :find_task
    fail Macro::Semantic(failure: :not_found), fail_fast: true
    step :set_model
    step Contract::Build(constant: Api::V1::Comment::Contract::Create)
    step Contract::Validate(key: :comment)
    step Contract::Persist()
    fail Macro::ContractErrors(error: I18n.t('errors.unprocessable'))
    pass :set_serializer
    pass Macro::Semantic(success: :created)

    def find_task(ctx, current_user:, params:, **)
      ctx[:task] = current_user.tasks.find_by(id: params[:task_id])
    end

    def set_model(ctx, task:, **)
      ctx[:model] = task.comments.build
    end

    def set_serializer(ctx, model:, **)
      ctx[:serializer] = Api::V1::Comment::Serializer::Show.new(model)
    end
  end
end 
