require "pry"
require "pry_command_set_registry/version"
require "pry_command_set_registry/registry"
require "pry_command_set_registry/command_set"
require "pry_command_set_registry/commands"
require "pry_command_set_registry/commands_command_set"

# The namespace and primary access point for addressing the
# PryCommandSetRegistry plugin. Home to the Registry singleton, the primary
# store of registered command sets.
module PryCommandSetRegistry
  class << self
    extend Forwardable
    # The registry singleton that stores all defined command sets.
    # @return [PryCommandSetRegistry::Registry]
    attr_accessor :registry

    # @!method command_set(name)
    #   Attempts to look up a registered command set with the given name. If the
    #   name starts with a colon, the colon is removed prior to lookup.
    #   @param [String,Symbol] name The name of a registered command set to
    #     attempt to retrieve.
    #   @return [PryCommandSetRegistry::CommandSet] if a command set with the
    #     given name was found.
    #   @return [nil] if no command set with the given name was found.
    #   @see PryCommandSetRegistry::Registry#command_set
    # @!method command_sets
    #   The Hash mapping of all registered command sets.
    #   @return [Hash{String => PryCommandSetRegistry::CommandSet}]
    #   @see PryCommandSetRegistry::Registry#command_sets
    # @!method define_command_set(name, description, options = {}, &block)
    #   Helper method for defining a command set and registering it immediately.
    #   All arguments are passed directly to
    #   {PryCommandSetRegistry::CommandSet#initialize CommandSet#initialize} to
    #   instantiate a new command set.
    #
    #   @param [String,Symbol] name The name that should be given to the command
    #     set. The provided name will be displayed by the `list-sets` command and
    #     is used to identify the command set when calling the `import-set`
    #     command.
    #   @param [String] description A description of the command set. The provided
    #     description will be displayed by the `list-sets` command.
    #   @param [Hash{Symbol=>String}] options Optional arguments.
    #   @option options [String] group A group name to apply to all commands in
    #     the command set. This group will be displayed in commands like `help`,
    #     however depending on the version of pry it may be sentence cased when
    #     displayed. When no group is provided, Pry will use `(other)` by default.
    #   @yield The provided block is evaluated by the command set instance and is
    #     used to define commands and configure the command set in other ways.
    #   @example Create a new CommandSet with a `hello-world` command
    #     PryCommandSetRegistry.define_command_set("Examples", "Example Commands", :group => "Examples") do
    #       command("hello-world", "Greets the world") do
    #         _pry_.outputter.puts("Hello world!")
    #       end
    #     end
    #   @raise [ArgumentError] if no block is given.
    #   @return [PryCommandSetRegistry::CommandSet] The command set instance created.
    #   @see PryCommandSetRegistry::Registry#define_command_set
    #   @see PryCommandSetRegistry::CommandSet#initialize
    def_delegators :registry, :command_set, :command_sets, :define_command_set
  end
  self.registry ||= Registry.new
  private_class_method :registry=
end

Pry.commands.import(PryCommandSetRegistry::CommandsCommandSet)
