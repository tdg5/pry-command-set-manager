require "test_helper"

class CommandsTest < PryCommandSetRegistry::TestCase
  include PryTestCase::CommandHelpers

  context "import-set" do
    should "raise Pry::CommandError if no set name is given" do
      assert_raises(Pry::CommandError) do
        command_exec_direct("import-set")
      end
    end

    should "raise NameError if caught NameError doesn't match command set" do
      context = Pry.binding_for(Object.new)
      assert_raises(NameError) do
        command_exec_direct("import-set command_set", :target => context)
      end
    end

    should "retrieve defined command set if one exists" do
      registry_command_called = false
      PryCommandSetRegistry.define_command_set("Test", "test") do
        command("test", "test") do
          registry_command_called = true
        end
      end
      command_exec_cli("import-set Test")
      command_exec_cli("test")
      assert_equal true, registry_command_called
    end

    should "favor command sets that resolve against the current binding" do
      registry_command_called = false
      PryCommandSetRegistry.define_command_set("Test", "test") do
        command("test", "test") do
          registry_command_called = true
        end
      end

      context_command_called = false
      test_set = PryCommandSetRegistry::CommandSet.new("Test", "test") do
        command("test", "test") do
          context_command_called = true
        end
      end
      test_struct = Struct.new(:command_set)
      test_instance = test_struct.new(test_set)
      context = Pry.binding_for(test_instance)
      command_exec_cli("import-set command_set", :context => context)
      command_exec_cli("test")
      assert_equal true, context_command_called
      assert_equal false, registry_command_called
    end

    should "fallback to registry if eval result doesn't seem to be a command set" do
      registry_command_called = false
      PryCommandSetRegistry.define_command_set("TestCommand", "test") do
        command("test", "test") do
          registry_command_called = true
        end
      end

      some_const = Object.new
      # This will return false anyway, but make sure it gets called to ensure
      # the eval is resolving to the expected object before falling back.
      some_const.expects(:respond_to?).with(:commands).returns(false)
      Object::TestCommand = some_const
      context = Pry.binding_for(Object.new)
      command_exec_cli("import-set TestCommand", :context => context)
      command_exec_cli("test")
      assert_equal true, registry_command_called
    end
  end

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
