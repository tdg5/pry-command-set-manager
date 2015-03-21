module PryCommandSetRegistry::Commands
  # Pry command providing a list of all registered command sets.
  class ListSetsCommand < Pry::ClassCommand
    match "list-sets"
    description "List registered command sets."
    banner <<-BANNER
      Usage: list-sets

      List registered command sets.
    BANNER

    # Displays a list of all registered command sets.
    #
    # @return [void]
    def process
      _pry_.output.puts "Registered Command Sets:"
      _pry_.output.puts format_command_set_listing(PryCommandSetRegistry.command_sets)
    end

    private

    # Formats the provided list of command sets in a human-friendly format.
    #
    # @param [Array<PryCommandSetRegistry::CommandSet>] A collection of command
    #   sets.
    # @return [String] The human-friendly format list of the command sets.
    def format_command_set_listing(command_sets)
      return "" if command_sets.none?
      max_len = command_sets.keys.max_by(&:length).length
      sets = command_sets.map do |set_name, set|
        "  #{set_name.ljust(max_len)}  -  #{set.description}"
      end
      sets.join("\n")
    end
  end
end
