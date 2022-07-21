# frozen_string_literal: true

class Api::V1::ProjectsController < AuthorizedController
  def create
    endpoint operation: Api::V1::Project::Operation::Create
  end

  def update
    endpoint operation: Api::V1::Project::Operation::Update
  end

  def destroy
    endpoint operation: Api::V1::Project::Operation::Destroy
  end
end
