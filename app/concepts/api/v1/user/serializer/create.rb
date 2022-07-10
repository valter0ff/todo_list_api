# frozen_string_literal: true

module Api::V1::User::Serializer
  class Create < ApplicationSerializer
    attribute :username

    set_type :user
#     set_id :user.id
  end
end
