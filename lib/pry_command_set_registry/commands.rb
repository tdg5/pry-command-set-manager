module PryCommandSetRegistry
  desc = "Commands for interacting with the Pry command set registry"
  Commands = CommandSet.new("PryCommandSetRegistry", desc, :group => "Command Set Registry") do
    command("import-set", "Import a Pry command set") do |command_set_name|
      raise Pry::CommandError, "Provide a command set name" if command_set_name.nil?

      begin
        set = target.eval(command_set_name)
      rescue NameError
        set = PryCommandSetRegistry.command_set(command_set_name)
        ::Kernel.raise if set.nil?
      end
      _pry_.commands.import(set)
    end

    command("list-sets", "List registered command sets") do
      _pry_.output.puts "Registered Command Sets:"
      _pry_.output.puts format_command_set_listing(PryCommandSetRegistry.command_sets)
    end

    helpers do
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
end
