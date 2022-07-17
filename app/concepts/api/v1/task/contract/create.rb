# frozen_string_literal: true

module Api::V1::Task::Contract
  class Create < ApplicationContract
    property :name

    validation :default do
      configure { config.namespace = :task }

      required(:name).filled(:str?)
    end
  end
end
