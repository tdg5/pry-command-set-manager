# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pry_command_set_registry/version"

Gem::Specification.new do |spec|
  spec.name          = "pry-command-set-registry"
  spec.version       = PryCommandSetRegistry::VERSION
  spec.authors       = ["Danny Guinther"]
  spec.email         = ["dannyguinther@gmail.com"]
  spec.summary       = %q{Plugin for managing registration and loading of command sets in pry.}
  spec.description   = %q{Plugin for managing registration and loading of command sets in pry.}
  spec.homepage      = "https://github.com/tdg5/pry-command-set-registry"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "pry"
end
