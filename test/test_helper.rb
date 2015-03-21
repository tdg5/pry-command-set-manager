if ENV["CI"]
  require "simplecov"
  require "coveralls"
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.root(File.expand_path("../..", __FILE__))
  SimpleCov.start do
    add_filter "test"
  end
end

require "minitest/autorun"
require "mocha/setup"
require "pry_test_case"
require "pry_test_case/command_helpers"
require "pry_command_set_registry"

# Use alternate shoulda-style DSL for tests
module PryCommandSetRegistry
  class TestCase < Minitest::Spec
    class << self
      alias :setup :before
      alias :teardown :after
      alias :context :describe
      alias :should :it
    end
  end
end
