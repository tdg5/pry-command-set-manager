require "test_helper"

class CommandsTest < PryCommandSetRegistry::TestCase
  context "import-set" do
    should "raise Pry::CommandError if no set name is given" do
      assert_raises(Pry::CommandError) do
        Pry.commands.run_command({}, "import-set")
      end
    end

    should "raise NameError if caught NameError doesn't match command set" do
      context = Pry.binding_for(Object.new)
      assert_raises(NameError) do
        Pry.commands.run_command({ :target => context }, "import-set", "command_set")
      end
    end

    should "retrieve defined command set if one exists" do
      registry_command_called = false
      PryCommandSetRegistry.define_command_set("Test", "test") do
        command("test", "test") do
          registry_command_called = true
        end
      end
      run_command("import-set Test")
      run_command("test")
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
      run_command("import-set command_set", :context => context)
      run_command("test")
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
      run_command("import-set TestCommand", :context => context)
      run_command("test")
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
      run_command("list-sets", :output => output)
      assert_equal "Registered Command Sets:\n\n", output.string
    end

    should "List registered sets" do
      output = StringIO.new
      name = "Foo"
      desc = "Bar"
      PryCommandSetRegistry.define_command_set(name, desc) {}
      run_command("list-sets", :output => output)
      expected_output = "Registered Command Sets:\n  Foo  -  Bar\n"
      assert_equal expected_output, output.string
    end
  end

  def run_command(command, options = {})
    Pry.run_command(command, options)
  end
end
