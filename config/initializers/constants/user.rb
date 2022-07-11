# frozen_string_literal: true

module Constants
  module User
    USER_NAME_SIZE = (3..50).freeze
    PASSWORD_SIZE = 8
    PASSWORD_FORMAT = /\A[A-Za-z0-9]+\z/.freeze
  end
end
