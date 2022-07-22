# frozen_string_literal: true

require 'image_processing/mini_magick'

class ImageUploader < ApplicationUploader
  SMALL_VERSION = [150, 150].freeze
  MEDIUM_VERSION = [350, 350].freeze

  Attacher.validate do
    validate_extension Constants::Images::IMAGE_EXTENSIONS
    validate_mime_type Constants::Images::IMAGE_MIME_TYPES
    validate_max_size Constants::Images::IMAGE_MAX_MB_SIZE.megabytes
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      small: magick.resize_to_limit!(*SMALL_VERSION),
      medium: magick.resize_to_limit!(*MEDIUM_VERSION)
    }
  end
end
