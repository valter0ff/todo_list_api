# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { FFaker::Lorem.unique.word }
    deadline { DateTime.now.next_week }
    project

    transient do
      comments_count { 2 }
    end

    trait :with_comments do
      comments { build_list(:comment, comments_count) }
    end
  end
end
