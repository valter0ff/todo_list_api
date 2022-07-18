# frozen_string_literal: true

module Api::V1::Project::Contract
  class Save < ApplicationContract
    property :title

    validation :default do
      configure { config.namespace = :project }

      required(:title).filled(:str?)
    end

    validation :uniqueness, if: :default do
      configure do
        option :form
        config.namespace = :project

        def unique_title?(value)
          !Project.where.not(id: form.model.id).exists?(title: value)
        end
      end

      required(:title).value(unique_title?: :title)
    end
  end
end
