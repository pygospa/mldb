require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

selenium_url = "http://chrome:4444/wd/hub"

Capybara.register_driver :selenium_remote do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(ignore-certificate-errors text-type)}
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: selenium_url,
    desired_capabilities: capabilities)
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_remote
    host! "http://test:3001"
  end

  config.include FactoryBot::Syntax::Methods
end
