require "test_helper"

class RegistryTest < PryCommandSetRegistry::TestCase
  Subject = PryCommandSetRegistry::Registry

  context "instance_methods" do
    subject { Subject.new }

    context "#initialize" do
      should "initialize #command_sets to an empty Hash" do
        assert_equal({}, subject.command_sets)
      end
    end

    context "#define_command_set" do
      should "create a new CommandSet with the given args" do
        name = "foo"
        description = "bar"
        group = "Test"
        opts = { :group => group }
        called = false
        command_set_proc = proc { called = true }
        command_set = subject.define_command_set(name, description, opts, &command_set_proc)
        assert_equal name, command_set.name
        assert_equal description, command_set.description
        assert_equal group, command_set.group
        assert_equal true, called, "CommandSet proc was not called!"
      end
    end
  end
end
