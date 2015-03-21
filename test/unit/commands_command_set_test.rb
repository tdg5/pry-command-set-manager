require "test_helper"

class CommandsCommandSetTest < PryCommandSetRegistry::TestCase
  Subject = PryCommandSetRegistry::CommandsCommandSet

  subject { Subject }

  context "commands" do
    Subject.auto_import_commands.each do |command|
      should "include #{command.name}" do
        assert_equal command, subject[command.match]
      end
    end
  end

  context "auto-import" do
    should "be imported into Pry.commands automatically" do
      subject.each do |match, command|
        assert_equal Pry.commands[match], command
      end
    end
  end
end
