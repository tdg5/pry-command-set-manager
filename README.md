# PryCommandSetRegistry
[![Gem Version](https://badge.fury.io/rb/pry-command-set-registry.svg)](http://badge.fury.io/rb/pry-command-set-registry)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/gems/pry-command-set-registry)
[![Build Status](https://travis-ci.org/tdg5/pry-command-set-registry.svg)](https://travis-ci.org/tdg5/pry-command-set-registry)
[![Coverage Status](https://coveralls.io/repos/tdg5/pry-command-set-registry/badge.svg)](https://coveralls.io/r/tdg5/pry-command-set-registry)
[![Code Climate](https://codeclimate.com/github/tdg5/pry-command-set-registry/badges/gpa.svg)](https://codeclimate.com/github/tdg5/pry-command-set-registry)
[![Dependency Status](https://gemnasium.com/tdg5/pry-command-set-registry.svg)](https://gemnasium.com/tdg5/pry-command-set-registry)

Plugin facilitating easy definition and importation of command sets for
[Pry](https://github.com/pry/pry). Creates a central registry for command sets 

## Installation

Add this line to your application's Gemfile:

```bash
gem 'pry-command-set-registry'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install pry-command-set-registry
```

## Usage

`Pry` should handle loading the plugin automatically. If not, you can require the
plugin like so:

```ruby
require "pry-command-set-registry"
```

### Commands and Command Set Definition

Once the plugin has been loaded you can view the commands it adds to `pry` using
the `help` command in `pry`:

```
$ pry
[1] pry(main)> help
# ... Skipping unrelated commands ...

Command set registry
  import-set         Import a pry command set
  list-sets          List registered command sets

[2] pry(main)>
```

The `import-set` and `list-sets` commands are the primary means of interacting
with the command set registry in `Pry`.

#### The `list-sets` command

The `list-sets` command displays a list of all registered command sets. Unless
you define your own command sets or include another library or plugin that
registers a command set, this list will be empty initially:

```
[2] pry(main)> list-sets
Registered Command Sets:

[3] pry(main)>
```

#### Defining a command set

Defining and registering a command set can be accomplished via the
`PryCommandSetRegistry` constant. In particular,
[`PryCommandSetRegistry.define_command_set`](http://www.rubydoc.info/gems/pry-command-set-registry/PryCommandSetRegistry.define_command_set)
provides a thin wrapper around [`Pry::CommandSet#block_command`](http://www.rubydoc.info/github/pry/pry/Pry/CommandSet:block_command)
allowing for the definition of new command sets.

Consider the following command set definition complimenting [Pry's poetic
side](https://github.com/pry/pry/blob/5e8d69e8b38b5df4c520e5faff74533c16f531a0/lib/pry/commands/easter_eggs.rb#L41)
with something a little more punk rock:

```ruby
PryCommandSetRegistry.define_command_set("PunkRock", "Pry, but more punk rock", :group => "PunkRock") do
  london_calling = <<-LONDON_CALLING
  --
  London calling to the faraway towns
  Now war is declared and battle come down

  London calling to the underworld
  Come out of the cupboard, you boys and girls

  London calling, now don't look to us
  Phony Beatlemania has bitten the dust

  London calling, see we ain't got no swing
  'Cept for the ring of that truncheon thing

  The ice age is coming, the sun is zooming in
  Meltdown expected, the wheat is growin' thin
  Engines stop running, but I have no fear
  'Cause London is drowning, and I, I live by the river

                        -- The Clash
  LONDON_CALLING
  command("london-calling", "If you have to ask then you need more help than Pry can provide") do
    output.puts(london_calling)
  end
end
```

If we copy and paste the above into `Pry`, we'll have defined and registered our
first command set! Once a command set has been registered, it will appear when
the `list-sets` command is invoked:

```
[4] pry(main)> list-sets
Registered Command Sets:
  PunkRock  -  Pry, but more punk rock

[5] pry(main)>
```

#### The `import-set` command

To import a registered command set into the current `Pry` session, use the
`import-set` command. The `import-set` command is a [built-in `Pry` command](https://github.com/pry/pry/blob/5e8d69e8b38b5df4c520e5faff74533c16f531a0/lib/pry/commands/import_set.rb),
but it's worth noting that `PryCommandSetRegistry` overrides the default command
to include fallback behavior for retrieving command sets from the registry
[[source]](https://github.com/tdg5/pry-command-set-registry/blob/4f9914969dcfa4a826c9672bd152e12d2e7e37f6/lib/pry_command_set_registry/commands.rb#L7).
This extended behavior allows command sets to be included in a variety of
formats. For example, each of the following will all import the `PunkRock`
command set into the current `Pry` session:

```
[5] pry(main)> import-set PunkRock
[6] pry(main)> import-set "PunkRock"
[7] pry(main)> import-set :PunkRock
```

Even when a constant is defined with the same name as a command set, a constant
style name can still be used. This is possible because `PryCommandSetRegistry`
uses a registry that is separate from Ruby's constants. At lookup time if
`PryCommandSetRegistry` evaluates the given name as a constant, but that constant
doesn't look like a command set, it will fallback to checking the registry for a
command set with the same name. For example, ignoring the fact that we've already
imported the `PunkRock` command set three times, the following would still work
as expected:

```
[8] pry(main)> PunkRock = "Never Mind the Bollocks"
[9] pry(main)> import-set PunkRock
```

Now that we've imported the `PunkRock` command set, the commands it provides
will appear when the `help` command is invoked:

```
[10] pry(main)> help
# ... Skipping unrelated commands ...
PunkRock
  london-calling     If you have to ask then you need more help than Pry can provide

[11] pry(main)>
```

Finally, we can invoke the added command by name:

```
[11] pry(main)> london-calling
  --
  London calling to the faraway towns
  Now war is declared and battle come down

  London calling to the underworld
  Come out of the cupboard, you boys and girls

  London calling, now don't look to us
  Phony Beatlemania has bitten the dust

  London calling, see we ain't got no swing
  'Cept for the ring of that truncheon thing

  The ice age is coming, the sun is zooming in
  Meltdown expected, the wheat is growin' thin
  Engines stop running, but I have no fear
  'Cause London is drowning, and I, I live by the river

                        -- The Clash

[12] pry(main)>
```

### Pry on, dude!

That's about it for basic usage of `PryCommandSetRegistry`. Make sure to check
out the [`PryCommandSetRegistry` docs](http://www.rubydoc.info/gems/pry-command-set-registry)
for more in-depth coverage of the inner workings of `PryCommandSetRegistry`.
Also make sure to check out the excellent [page on custom commands in the
`Pry` wiki](https://github.com/pry/pry/wiki/Custom-commands)!

## Contributing

1. Fork it ( https://github.com/tdg5/pry-command-set-registry/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
