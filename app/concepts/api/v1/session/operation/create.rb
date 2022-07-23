# frozen_string_literal: true

module Api::V1::Session::Operation
  class Create < ApplicationOperation
    step Macro::Contract::Schema(Api::V1::Session::Contract::Create)
    step Contract::Validate(), fail_fast: true
    step :set_model
    fail Macro::Semantic(failure: :not_found), fail_fast: true
    step :authenticate
    fail :add_contract_error
    fail Macro::Semantic(failure: :unauthorized)
    step :set_session_tokens
    pass :set_serializer
    pass Macro::Semantic(success: :created)

    def set_model(ctx, params:, **)
      ctx[:model] = User.find_by(username: params[:username])
    end

    def authenticate(_ctx, model:, params:, **)
      model.authenticate(params[:password])
    end

    def add_contract_error(ctx, **)
      ctx['contract.default'].errors.messages[:base] = I18n.t('errors.rules.session.unauthorized')
    end

    def set_session_tokens(ctx, model:, **)
      payload = { user_id: model.id }
      ctx[:session_tokens] = JWTSessions::Session.new(refresh_by_access_allowed: true, payload: payload).login
    end

    def set_serializer(ctx, model:, session_tokens:, **)
      ctx[:serializer] = Api::V1::Lib::UserSerializer::Show.new(model, meta: session_tokens)
    end
  end
end
