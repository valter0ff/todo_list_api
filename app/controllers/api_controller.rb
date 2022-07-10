# frozen_string_literal: true

class ApiController < ActionController::API
  include SimpleEndpoint::Controller
  include DefaultEndpoint
  include JWTSessions::RailsAuthorization

  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  private

  def not_authorized
    head(:unauthorized)
  end
end
