module PryCommandSetRegistry
  class CommandSet < Pry::CommandSet
    # The default group name that Pry gives to commands without a group.
    DEFAULT_GROUP_NAME = "(other)".freeze

    def initialize(name, description, options = {}, &block)
      raise ArgumentError, "Block required!" unless block_given?
      super(&block)
      @description = description
      @name = name.to_s
      @group = options[:group] || DEFAULT_GROUP_NAME
      apply_group_name_to_commands
    end

    private

    def apply_group_name_to_commands
      return false if group == DEFAULT_GROUP_NAME
      each { |command_name, command| command.group(group) }
      true
    end
  end
end
