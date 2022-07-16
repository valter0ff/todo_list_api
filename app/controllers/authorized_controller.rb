# frozen_string_literal: true

class AuthorizedController < ApiController
  before_action :authorize_access_request!

  private

  def endpoint_options
    { current_user: current_user, params: params }
  end

  def current_user
    @current_user ||= User.find_by(id: payload['user_id']) || raise(JWTSessions::Errors::Unauthorized)
  end
end
