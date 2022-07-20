# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { FFaker::Lorem.unique.word }
    deadline { DateTime.now.next_week }
    project

    trait :with_comments do
      comments { [association(:comment, task: instance), association(:comment, task: instance)] }
    end
  end
end
