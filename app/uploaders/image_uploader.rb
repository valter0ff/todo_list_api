# frozen_string_literal: true

class ImageUploader < ApplicationUploader
  Attacher.validate do
    validate_extension Constants::Images::IMAGE_EXTENSIONS
    validate_mime_type Constants::Images::IMAGE_MIME_TYPES
    validate_max_size Constants::Images::IMAGE_MAX_MB_SIZE.megabytes
  end
end
