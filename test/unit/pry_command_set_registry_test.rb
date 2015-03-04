require "test_helper"

class PryCommandSetRegistryTest < PryCommandSetRegistry::TestCase
  Subject = PryCommandSetRegistry

  context Subject.name do
    subject { Subject }

    should "be defined" do
      assert defined?(subject), "Expected #{subject.name} to be defined!"
    end

    should "have a registry" do
      assert_kind_of PryCommandSetRegistry::Registry, Subject.registry
    end

    should "delegate ::command_set to ::registry" do
      query = "Foo"
      Subject.registry.expects(:command_set).with(query)
      Subject.command_set(query)
    end

    should "delegate ::command_sets to ::registry" do
      Subject.registry.expects(:command_sets)
      Subject.command_sets
    end

    should "delegate ::define_command_set to ::registry" do
      name = "Foo"
      desc = "Bar"
      Subject.registry.expects(:define_command_set).with(name, desc)
      Subject.define_command_set(name, desc)
    end
  end
end
