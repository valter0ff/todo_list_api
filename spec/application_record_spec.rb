# frozen_string_literal: true

RSpec.describe ApplicationRecord do
  it do
    expect(described_class.abstract_class).to be_truthy
  end
end
