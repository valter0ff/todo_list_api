# frozen_string_literal: true

module Api::V1::Project::Serializer
  class Save < ApplicationSerializer
    attributes :title, :created_at, :updated_at

    set_type :project
  end
end
