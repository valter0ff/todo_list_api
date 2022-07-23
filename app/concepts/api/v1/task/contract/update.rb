# frozen_string_literal: true

module Api::V1::Task::Contract
  class Update < ApplicationContract
    property :name
    property :status

    validation :task_status do
      configure do
        option :form
        config.namespace = :task

        def in_progress?(_value)
          form.model.in_progress?
        end
      end

      required(:status).value(:in_progress?)
    end

    validation :default, if: :task_status do
      configure { config.namespace = :task }

      required(:name).filled(:str?)
    end
  end
end
