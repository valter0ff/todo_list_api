# frozen_string_literal: true

module Helpers
  module SessionsHelper
    def create_token(user:)
      user_id = user.id
      payload = { user_id: user_id }
      tokens = JWTSessions::Session.new(refresh_by_access_allowed: true, payload: payload).login
      tokens[:access]
    end
  end
end
