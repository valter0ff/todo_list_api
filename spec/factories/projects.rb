# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { FFaker::Name.unique.name }
    user

    trait :with_tasks do
      tasks { [association(:task), association(:task)] }
    end
  end
end
