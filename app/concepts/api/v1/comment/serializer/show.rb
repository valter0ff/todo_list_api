# frozen_string_literal: true

module Api::V1::Comment::Serializer
  class Show < ApplicationSerializer
    set_type :comment
    attributes :body, :created_at, :updated_at
  end
end
