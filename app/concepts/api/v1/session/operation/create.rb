# frozen_string_literal: true

module Api::V1::Session::Operation
  class Create < ApplicationOperation
    step Macro::Contract::Schema(Api::V1::Session::Contract::Create)
    step Contract::Validate(), fail_fast: true
    pass :prepare_params
    step :set_model
    step :authenticate
#     step :debug_pry
    fail :add_contract_error
    fail Macro::Semantic(failure: :unauthorized)
    step :set_session_tokens
#     step :debug_pry2
    pass :set_serializer
    pass Macro::Semantic(success: :created)

#     def debug_pry(ctx, **)
#       binding.pry
#     end
#
#     def debug_pry2(ctx, **)
#       binding.pry
#     end

    def prepare_params(_ctx, params:, **)
      params[:username] = params[:username].strip
    end

    def set_model(ctx, params:, **)
      ctx[:model] = User.find_by(username: params[:username])
    end

    def authenticate(ctx, model:, params:, **)
      model.authenticate(params[:password])
    end

    def add_contract_error(ctx, **)
      ctx['contract.default'].errors.messages[:base] = I18n.t('errors.rules.session.unauthorized')
    end

    def set_session_tokens(ctx, model:, **)
      payload = { user_id: model.id }
      ctx[:session_tokens] = JWTSessions::Session.new(payload: payload).login
    end

    def set_serializer(ctx, model:, session_tokens:, **)
      ctx[:serializer] = Api::V1::Session::Serializer::Create.new(session_tokens, model)
    end
  end
end
