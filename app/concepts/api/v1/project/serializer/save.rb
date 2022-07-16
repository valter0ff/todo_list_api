# frozen_string_literal: true

module Api::V1::Project::Serializer
  class Save < ApplicationSerializer
    attributes :title, :created_at, :updated_at

    set_type :project
    belongs_to :user, serializer: Api::V1::User::Serializer::Create
  end
end
