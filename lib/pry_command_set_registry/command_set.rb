module PryCommandSetRegistry
  class CommandSet < Pry::CommandSet
    # The default group name that Pry gives to commands without a group.
    DEFAULT_GROUP_NAME = "(other)".freeze

    # The description of the command set provided at creation.
    attr_reader :description

    # The group name given to the command set at creation.
    attr_reader :group

    # The name of the command set provided at creation.
    attr_reader :name

    # Creates a new command set.
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
    #   CommandSet.new("Examples", "Example Commands", :group => "Examples") do
    #     command("hello-world", "Greets the world") do
    #       _pry_.outputter.puts("Hello world!")
    #     end
    #   end
    # @raise [ArgumentError] if no block is given.
    # @return [PryCommandSetRegistry::CommandSet] The instance created.
    def initialize(name, description, options = {}, &block)
      raise ArgumentError, "Block required!" unless block_given?
      super(&block)
      @description = description
      @name = name.to_s
      @group = options[:group] || DEFAULT_GROUP_NAME
      apply_group_name_to_commands
    end

    private

    # If a group name was provided, adds that group to all commands in the
    # command set.
    #
    # @return [true] if the group name was added to all commands.
    # @return [false] if group no group was provided at instantiation.
    def apply_group_name_to_commands
      return false if group == DEFAULT_GROUP_NAME
      each { |command_name, command| command.group(group) }
      true
    end
  end
end
