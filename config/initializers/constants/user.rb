# frozen_string_literal: true

module Constants
  module User
    USERNAME_MIN_SIZE = 3
    USERNAME_MAX_SIZE = 50
    PASSWORD_SIZE = 8
    PASSWORD_FORMAT = /\A[A-Za-z0-9]+\z/.freeze
  end
end
