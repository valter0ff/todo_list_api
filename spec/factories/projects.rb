# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { FFaker::Name.unique.name }
    user

    transient do
      tasks_count { 2 }
    end

    trait :with_tasks do
      tasks { build_list(:task, tasks_count) }
    end
  end
end
