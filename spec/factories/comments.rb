# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { FFaker::Name.unique.name }
    task
  end
end
