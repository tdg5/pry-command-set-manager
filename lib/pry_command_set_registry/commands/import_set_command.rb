module PryCommandSetRegistry::Commands
  # Pry command providing a means to import a command set into the current Pry
  # session.
  class ImportSetCommand < Pry::ClassCommand
    match "import-set"
    description "Import a Pry command set."
    banner <<-BANNER
      Usage: import-set <command_set_name>

      Import a Pry command set.
    BANNER

    # Attempts to lookup and import the specified command set into the current
    # Pry session. This command is designed to give priority to command sets
    # that resolve against the current binding if any exist. Efforts to resolve
    # the command set name proceed as follows:
    #
    # 1. Evaluate provided command set name against current binding.
    #      a. If evaluation succeeds and the result of evaluation looks like a
    #         command set, the result object will be imported.
    #      b. If the evaluation succeeds and the result of the evaluation does
    #         not look like a command set, the result is discarded.
    # 2. If the evaluation fails resulting in a NameError, the command will
    #    attempt to use the given command set name to retrieve a command set
    #    from the command set registry.
    #      a. If a command set is found in the registry with a name matching the
    #         given command set name, that command set is imported into the current
    #         Pry session.
    #      b. If no command set is found in the registry with the given command
    #         set name, the NameError is raised.
    #
    # @raise [Pry::CommandError] if no command set name is given.
    # @return [void]
    def process(command_set_name)
      raise Pry::CommandError, "Provide a command set name" if command_set_name.nil?

      begin
        set = target.eval(command_set_name)
        unless set.respond_to?(:commands) && set.commands.is_a?(Hash)
          registered_set = PryCommandSetRegistry.command_set(command_set_name)
          set = registered_set if registered_set
        end
      rescue NameError
        set = PryCommandSetRegistry.command_set(command_set_name)
        raise if set.nil?
      end
      _pry_.commands.import(set)
    end
  end
end
