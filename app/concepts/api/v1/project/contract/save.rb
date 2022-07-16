# frozen_string_literal: true

module Api::V1::Project::Contract
  class Save < ApplicationContract
    property :title
   
    validation :default do
      configure { config.namespace = :project }

      required(:title).filled(:str?)
    end
  end
end
