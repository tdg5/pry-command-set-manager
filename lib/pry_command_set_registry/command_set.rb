module PryCommandSetRegistry
  class CommandSet < Pry::CommandSet
    attr_reader :commands, :description, :name

    def initialize(name, description, &block)
      raise "Block required!" unless block_given?
      super(&block)
      @description = description
      @name = name.to_s
      apply_group_name_to_commands
    end

    private

    def apply_group_name_to_commands
      commands.values.each { |command| command.group(name) }
    end
  end
end
