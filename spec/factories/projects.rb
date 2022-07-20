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
    
    trait :with_one_task do
      tasks { [build(:task)] }
    end
    
    factory :project_with_tasks do
      tasks { build_list(:task, tasks_count) }
    end
    
    factory :project_with_tasks_with_comments do
      transient do
        comments_count { 2 }
      end
      
      tasks { build_list(:task_with_comments, tasks_count, comments_count: comments_count) }
    end
  end
end
