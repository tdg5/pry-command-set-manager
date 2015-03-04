require "minitest/autorun"
require "mocha/setup"
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
