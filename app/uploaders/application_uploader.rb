# frozen_string_literal: true

class ApplicationUploader < Shrine
  plugin :derivatives, create_on_promote: true, versions_compatibility: true
  plugin :activerecord
  plugin :cached_attachment_data
  plugin :restore_cached_data
  plugin :validation
  plugin :validation_helpers
  plugin :pretty_location
  plugin :metadata_attributes
  plugin :determine_mime_type
  plugin :remove_invalid
end
