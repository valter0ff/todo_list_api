# frozen_string_literal: true

module Api::V1::Session::Serializer
  class Create < ApplicationSerializer

    set_type :session_tokens
    set_id { |tokens, model| model.id] }
  end
end
