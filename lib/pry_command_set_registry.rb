require "pry"
require "pry_command_set_registry/version"
require "pry_command_set_registry/registry"
require "pry_command_set_registry/command_set"
require "pry_command_set_registry/commands"

module PryCommandSetRegistry
  class << self
    extend Forwardable
    # The registry singleton that stores all defined command sets.
    # @return [PryCommandSetRegistry::Registry]
    attr_accessor :registry
    def_delegators :registry, :command_set, :command_sets, :define_command_set
  end
  self.registry ||= Registry.new
  private_class_method :registry=
end

Pry.commands.import(PryCommandSetRegistry::Commands)
