# frozen_string_literal: true

class Api::V1::TasksController < AuthorizedController
  def index
    endpoint operation: Api::V1::Task::Operation::Index
  end

  def create
    endpoint operation: Api::V1::Task::Operation::Create
  end

  def is_done
    endpoint operation: Api::V1::Task::Operation::IsDone
  end
  
  def update
    endpoint operation: Api::V1::Task::Operation::Update
  end
end
