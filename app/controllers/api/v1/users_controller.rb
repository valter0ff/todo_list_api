# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  def create
    endpoint operation: Api::V1::User::Operation::Create
  end
end
