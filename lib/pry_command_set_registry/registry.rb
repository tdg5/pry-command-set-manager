module PryCommandSetRegistry
  class Registry
    attr_reader :command_sets

    def initialize
      @command_sets = {}
    end

    def command_set(name)
      sanitized_name = name.to_s.sub(/^:/, "")
      command_sets[sanitized_name]
    end

    def define_command_set(name, description, &block)
      command_set = CommandSet.new(name, description, &block)
      command_sets[command_set.name] = command_set
    end
  end
end
