# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { FFaker::Lorem.unique.word }
    deadline { DateTime.now.next_week }
    project
  end
end
