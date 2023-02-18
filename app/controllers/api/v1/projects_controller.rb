# frozen_string_literal: true

class Api::V1::ProjectsController < AuthorizedController
  def create
    endpoint operation: Api::V1::Project::Operation::Create
  end
end
