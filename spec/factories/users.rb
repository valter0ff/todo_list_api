# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { FFaker::Lorem.word }
    password { 'qwerty12' }
    password_confirmation { 'qwerty12' }
  end
end
