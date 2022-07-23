# frozen_string_literal: true

module Api::V1::Lib::UserSerializer
  class Show < ApplicationSerializer
    attributes :username, :created_at, :updated_at

    set_type :user
    has_many :projects, serializer: Api::V1::Project::Serializer::Save
  end
end
