# frozen_string_literal: true

class Api::V1::CurrentUsersController < AuthorizedController
  def show
    endpoint operation: Api::V1::CurrentUser::Operation::Show
  end
end

