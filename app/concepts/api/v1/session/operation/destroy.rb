# frozen_string_literal: true

module Api::V1::Session::Operation
  class Destroy < ApplicationOperation
    step :destroy_session
    pass Macro::Semantic(success: :destroyed)

    def destroy_session(_ctx, payload:, **)
      session = JWTSessions::Session.new(payload: payload)
      session.flush_by_access_payload
    end
  end
end
