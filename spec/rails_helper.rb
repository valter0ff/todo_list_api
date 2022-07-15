# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  add_filter ['app/jobs', 'app/mailers']
  minimum_coverage 20 # 95
end

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

Dir['spec/support/**/*.rb', 'spec/support/**/**/*.rb', 'spec/support/**/**/**/*.rb'].each do |file|
  require Rails.root.join(file)
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Helpers::SessionsHelper
  config.include Helpers::ContractHelper
end

require 'swagger_helper'
