ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "shoulda"
require 'shoulda/context'
require "minitest-spec-rails"
require "minitest/reporters"
require "pry"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

