# frozen_string_literal: true

module Api::V1::User::Serializer
  class Create < ApplicationSerializer
    attributes :username, :created_at, :updated_at

    set_type :user
  end
end
