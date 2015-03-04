guard(:minitest, :all_after_pass => false, :all_on_start => false) do
  watch(%r{^lib/pry[_\-]command[_\-]set[_\-]registry\.rb$}) { "test" }
  watch(%r{^lib/pry_command_set_registry/(.+)\.rb$}) { |m| "test/unit/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^test/test_helper\.rb$}) { "test" }
end
