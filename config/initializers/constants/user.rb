# frozen_string_literal: true

module Constants
  module User
    USER_NAME_SIZE = (3..50)
    PASSWORD_FORMAT = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])\S{8}\z/.freeze
  end
end
