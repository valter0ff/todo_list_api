# frozen_string_literal: true

module Api::V1::CurrentUser::Operation
  class Show < ApplicationOperation
    step :set_model
    step :serializer

    def set_model(ctx, **); end

    def serializer(ctx, model:, **); end
  end
end
