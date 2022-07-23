# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project
  acts_as_list scope: :project

  enum status: { in_progress: 0, done: 1 }
end
