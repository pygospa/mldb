require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

selenium_url = "http://chrome:4444/wd/hub"

Capybara.register_driver :selenium_remote do |app|
  Capybara::Selenium::Driver.new(app, browser: :remote, url: selenium_url, desired_capabilities: :chrome)
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_remote
    ip = Socket.ip_address_list.detect { |addr| addr.ipv4_private? }.ip_address
    host! "http://#{ip}:#{Capybara.server_port}"
  end
end
