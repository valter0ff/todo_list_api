# frozen_string_literal: true

class Api::V1::SessionsController < ApiController
  def create
    endpoint operation: Api::V1::Session::Operation::Create
  end

  def destroy
    authorize_access_request!
    endpoint operation: Api::V1::Session::Operation::Destroy, options: { payload: payload }
  end
end
