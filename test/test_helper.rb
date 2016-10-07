require 'simplecov'
SimpleCov.start

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
require "rails/test_help"
require 'minitest/reporters'
require 'webmock/minitest'
WebMock.disable_net_connect!(allow: /.*codeclimate.*/)

require 'factories'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new
Rails.backtrace_cleaner.remove_silencers!

# Rails.backtrace_cleaner.remove_silencers!

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.fixtures :all
end

require "generators/errdo/install_generator"

# rubocop:disable Style/ClassAndModuleChildren
class ActionDispatch::IntegrationTest

  # Default the authentication to nothing so that we don't have to deal with it on regular tests
  setup do
    Errdo.authorize_with { true }
  end

end

class ActionController::TestCase

  setup do
    Errdo.authorize_with { true }
  end

end
