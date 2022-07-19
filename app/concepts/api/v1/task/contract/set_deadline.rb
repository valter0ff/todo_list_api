# frozen_string_literal: true

module Api::V1::Task::Contract
  class SetDeadline < ApplicationContract
    property :status
    property :deadline

    validation :task_status do
      configure do
        option :form
        config.namespace = :task

        def is_done?(_value)
          form.model.active?
        end
      end

      required(:status).value(is_done?: :status)
    end

    validation :default, if: :task_status do
      configure { config.namespace = :task }

      required(:deadline).filled(:date_time?, gteq?: DateTime.now)
    end
  end
end
