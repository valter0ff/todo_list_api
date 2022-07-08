# frozen_string_literal: true

RSpec.describe ApplicationController do
  it do
    expect(described_class.superclass).to eq(ActionController::API)
  end
end
