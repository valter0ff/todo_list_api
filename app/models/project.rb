# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :project
end
