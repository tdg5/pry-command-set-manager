require "test_helper"

class ListSetsCommandTest < PryCommandSetRegistry::TestCase
  include PryTestCase::CommandHelpers

  context "list-sets" do
    setup do
      # Reset registry
      clean_registry = PryCommandSetRegistry::Registry.new
      PryCommandSetRegistry.send(:registry=, clean_registry)
    end

    should "List no registered sets when none are registered" do
      output = StringIO.new
      command_exec_cli("list-sets", :output => output)
      assert_equal "Registered Command Sets:\n\n", output.string
    end

    should "List registered sets" do
      output = StringIO.new
      name = "Foo"
      desc = "Bar"
      PryCommandSetRegistry.define_command_set(name, desc) {}
      command_exec_cli("list-sets", :output => output)
      expected_output = "Registered Command Sets:\n  Foo  -  Bar\n"
      assert_equal expected_output, output.string
    end
  end
end

