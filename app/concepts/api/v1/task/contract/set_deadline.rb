# frozen_string_literal: true

module Api::V1::Task::Contract
  class SetDeadline < ApplicationContract
    property :status
    property :deadline

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

      required(:deadline).filled(:date_time?, gteq?: DateTime.now)
    end
  end
end
