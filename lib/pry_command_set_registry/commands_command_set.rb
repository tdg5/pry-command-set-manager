module PryCommandSetRegistry
  desc = "Commands for interacting with the Pry command set registry"

  # Default commands for interacting with PryCommandSetRegistry imported into
  # Pry.
  CommandsCommandSet = CommandSet.new("PryCommandSetRegistry", desc, :group => "Command Set Registry") do
    def self.auto_import_commands
      [
        Commands::ImportSetCommand,
        Commands::ListSetsCommand,
      ]
    end

    auto_import_commands.each { |command| add_command(command) }
  end
end
