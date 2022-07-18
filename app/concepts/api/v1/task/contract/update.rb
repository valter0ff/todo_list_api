# frozen_string_literal: true

module Api::V1::Task::Contract
  class Update < ApplicationContract
    property :name

    validation :status do
      configure do
        config.namespace = :task

        def active?(value)
          value == 'active'
        end
      end

      required(:status).value(active?: :status)
    end

    validation :default, if: :status do
      configure { config.namespace = :task }

      required(:name).filled(:str?)
    end
  end
end
