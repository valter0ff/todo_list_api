# frozen_string_literal: true

module Api::V1::Task::Serializer
  class Show < ApplicationSerializer
    set_type :task
    attributes :name, :created_at, :updated_at, :status, :position

    attribute :deadline_date, if: proc { |record| record.deadline.present? } do |object|
      object.deadline.strftime('%d/%m/%Y')
    end

    attribute :deadline_time, if: proc { |record| record.deadline.present? } do |object|
      object.deadline.strftime('%R')
    end
  end
end
