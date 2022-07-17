# frozen_string_literal: true

module Api::V1::Task::Serializer
  class Show < ApplicationSerializer
    attributes :name, :created_at, :updated_at

    set_type :task
  end
end
