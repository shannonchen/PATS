require 'simplecov'
SimpleCov.start 'rails'
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- but we don't want them anyways, so comment them out...
  # fixtures :all  

  # Add more helper methods to be used by all tests here...
  def deny(condition)
    # a simple transformation to increase readability IMO
    assert !condition
  end
end