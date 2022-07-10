# frozen_string_literal: true

class ApplicationSerializer
  include JSONAPI::Serializer

  set_key_transform :dash
end
