# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { FFaker::Name.unique.name }
    task

    trait :with_image do
      image { Rack::Test::UploadedFile.new('spec/fixtures/images/valid_image.jpg', 'image/jpeg') }
    end
  end
end
