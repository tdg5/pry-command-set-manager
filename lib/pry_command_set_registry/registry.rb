module PryCommandSetRegistry
  # A registry of command sets and descriptions of those command sets.
  class Registry
    # The Hash mapping of all registered command sets.
    # @return [Hash{String => PryCommandSetRegistry::CommandSet}]
    attr_reader :command_sets

    # Creates a new command set registry.
    # @return [PryCommandSetRegistry::Registry] The registry instance.
    def initialize
      @command_sets = {}
    end

    # Attempts to look up a registered command set with the given name. If the
    # name starts with a colon, the colon is removed prior to lookup.
    #
    # @param [String,Symbol] name The name of a registered command set to
    #   attempt to retrieve.
    # @return [PryCommandSetRegistry::CommandSet] if a command set with the
    #   given name was found.
    # @return [nil] if no command set with the given name was found.
    def command_set(name)
      sanitized_name = name.to_s.sub(/^:/, "")
      command_sets[sanitized_name]
    end

    # Helper method for defining a command set and registering it immediately.
    # All arguments are passed directly to
    # {PryCommandSetRegistry::CommandSet#initialize CommandSet#initialize} to
    # instantiate a new command set.
    #
    # @param [String,Symbol] name The name that should be given to the command
    #   set. The provided name will be displayed by the `list-sets` command and
    #   is used to identify the command set when calling the `import-set`
    #   command.
    # @param [String] description A description of the command set. The provided
    #   description will be displayed by the `list-sets` command.
    # @param [Hash{Symbol=>String}] options Optional arguments.
    # @option options [String] group A group name to apply to all commands in
    #   the command set. This group will be displayed in commands like `help`,
    #   however depending on the version of pry it may be sentence cased when
    #   displayed. When no group is provided, Pry will use `(other)` by default.
    # @yield The provided block is evaluated by the command set instance and is
    #   used to define commands and configure the command set in other ways.
    # @example Create a new CommandSet with a `hello-world` command
    #   Registry.define_command_set("Examples", "Example Commands", :group => "Examples") do
    #     command("hello-world", "Greets the world") do
    #       _pry_.outputter.puts("Hello world!")
    #     end
    #   end
    # @raise [ArgumentError] if no block is given.
    # @return [PryCommandSetRegistry::CommandSet] The command set instance created.
    # @see PryCommandSetRegistry::CommandSet#initialize
    def define_command_set(name, description, options = {}, &block)
      command_set = CommandSet.new(name, description, options, &block)
      command_sets[command_set.name] = command_set
      command_set
    end
  end
end
