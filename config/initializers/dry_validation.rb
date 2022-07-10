# frozen_string_literal: true

require "reform/form/dry"

Reform::Form.class_eval do
  include Reform::Form::Dry
end

Rails.application.configure do
  Dry::Validation::Schema.configure do |config|
    config.messages = :i18n
  end

  Dry::Validation::Schema::Form.configure do |config|
    config.messages = :i18n
  end
end
