require "test_helper"

class PryCommandSetRegistryTest < PryCommandSetRegistry::TestCase
  SUBJECT = PryCommandSetRegistry

  context SUBJECT.name do
    subject { SUBJECT }

    should 'be defined' do
      assert defined?(subject), "Expected #{subject.name} to be defined!"
    end
  end
end
