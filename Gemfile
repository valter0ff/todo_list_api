# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby(File.read(File.join(File.dirname(__FILE__), '.ruby-version')).strip)

# System
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.6.2'
gem 'rails', '~> 6.1.5', '>= 6.1.5.1'

# Trailblazer bundle
gem 'dry-configurable', '0.12.1'
gem 'dry-validation', '0.11.1'
gem 'reform', '~> 2.2.0', '>= 2.2.4'
gem 'simple_endpoint', '~> 1.0.0'
gem 'trailblazer', '~> 2.1'

# JSON:API Serializer
gem 'jsonapi-serializer', '~> 2.1'
gem 'oj', '~> 3.11'

# Pagination
gem 'pagy', '~> 3.11'

# Uploading
gem 'image_processing', '~> 1.0'
gem 'shrine', '~> 3.0'

# Storing
gem 'redis-rails'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Authentication
gem 'bcrypt', '~> 3.1'
gem 'jwt_sessions', '~> 2.5'

# Api doc
gem 'rspec-rails', '~> 5.1.0'
gem 'rswag', '~> 2.4.0'

# Sorting
gem 'acts_as_list', '~> 1.0', '>= 1.0.4'

group :development, :test do
  gem 'awesome_print', '~>1.9.2'
  gem 'bullet', '~> 6.1'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'ffaker', '~> 2.18'
  gem 'pry-byebug', '~> 3.9'
  gem 'pry-rails', '~> 0.3.9'

  # Code quality
  gem 'brakeman', '~> 5.2.1', require: false
  gem 'bundle-audit', '~> 0.1.0', require: false
  gem 'fasterer', '~> 0.9.0', require: false
  gem 'i18n-tasks', '~> 0.9.34', require: false
  gem 'lefthook', '~> 0.7.2', require: false
  gem 'rails_best_practices', '~> 1.20', require: false
  gem 'rubocop', '~> 0.93.1', require: false
  gem 'rubocop-performance', '~> 1.10', require: false
  gem 'rubocop-rails', '~> 2.9', require: false
  gem 'rubocop-rspec', '~> 1.43', require: false
end

group :development do
  gem 'letter_opener', '~> 1.7'
  gem 'listen', '~> 3.4'
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0', '>= 2.0.1'
end

group :test do
  gem 'fuubar', '~> 2.5.1'
  gem 'json_matchers', '~> 0.11.1', require: 'json_matchers/rspec'
  gem 'mock_redis', '~> 0.27.3'
  gem 'pundit-matchers', '~> 1.7.0'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'rspec_junit_formatter', '~> 0.5.1'
  gem 'shoulda-matchers', '~> 4.5'
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'simplecov-lcov', '~> 0.8.0', require: false
  gem 'webdrivers', '~> 4.6', require: false
end
