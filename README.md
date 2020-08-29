# Tagrity

[![Build Status](https://travis-ci.com/RRethy/tagrity.svg?branch=master)](https://travis-ci.com/RRethy/tagrity)

Automatically regenerate your tags on file changes.

## Installation

```sh
$ gem install tagrity
```

## Quick Start

```sh
tagrity start
```

That's it! It will monitor the current directory and generate tags for any files which change and are not ignored by git.

To stop watching the current directory, use

```sh
tagrity stop
```

To view directories being watched, use

```sh
tagrity status
```

## Less Quick Start

When your computer is restarted, the process watching the directories will be killed. Add the following to your `~/.bashrc` (or `~/.zshrc`, etc.) to revive any killed processes automatically.

```sh
(tagrity revive &) &> /dev/null
```

To stop watching a directory that isn't the current working directory (but shows up in `tagrity status`), you can use:

```sh
tagrity stop --dir <path>
```

Where `<path>` is a relative or absolute path. You may be tempted to run `tagrity status` to get the pid and then kill it with `kill <pid>`. However, while this will work, `tagrity revive` will restart these processes (with different pids of course). `tagrity stop` will kill the process and stop `tagrity revive` from starting it up again.

To get info on what tags are being generated, you can run:

```sh
tagrity logs
```

For a full set of subcommands, try `tagrity help`.

## Configuration

Configuration can be done through use of a local `.tagrity_config.yml` file that looks like the following:

**NOTE:** Tagrity will also look for a global config file at `$XDG_CONFIG_HOME/tagrity/tagrity_config.yml` (usually this will be `~/.config/tagrity/tagrity_config.yml`). This will be overriden by a local config file.

**NOTE:** Tagrity needs to be restarted for configuration changes to take effect.

[Sample `tagrity_config.yml`](https://github.com/RRethy/tagrity/blob/master/sample_config.yml)

```yaml
# which command to use to generate tags for a specific file extension
# overrides default_command
# tag generation commands must support --append, -f, -L
# NOTE: Exuberant-ctags does NOT satisfy this requirement, instead use Universal-ctags
#
# Default: empty
extension_commands:
  rb: ripper-tags
  c: ctags
  go: gotags

# default command to generate tags
# command must support --append, -f, -L
#
# Default: ctags
default_command: ctags

# filename (relative to pwd) to generate tags into
#
# Default: tags
tagf: tags

# list of extensions to exclusively generate tags for
# this will take precendence over extensions_blacklist if it is non-empty
#
# Default: []
extensions_whitelist: [rb, c, h, js]

# list of extensions to not generate tags for
# this can will be ignored if extensions_whitelist is non-empty
#
# Default: []
extensions_blacklist: [erb, html, txt]

# which paths (relative to pwd) to ignore
# this is usually not needed since tagrity doesn't index files ignored by git
#
# Default: []
excluded_paths: [vendor, node_modules]
```

## Usage

```
Commands:
  tagrity help [COMMAND]  # Describe available commands or one specific command
  tagrity logs            # Print the logs for pwd
  tagrity revive          # Restart any tagrity processes that died
  tagrity start           # Start watching pwd
  tagrity status          # List running tagrity processes and the directories being watched
  tagrity stop            # Stop watching a directory (default to pwd)
  tagrity version         # print tagrity version
```

### start

```
Usage:
  tagrity start

Options:
  [--fg], [--no-fg]        # keep the tagrity process running in the foreground
  [--fresh], [--no-fresh]  # index the whole codebase before watching the file system. This will be slow if the codebase is large.

Start watching pwd
```

### stop

```
Usage:
  tagrity stop

Options:
  [--dir=DIR]  # directory to stop watching.
               # Default: /Users/rethy/ruby/tagrity

Stop watching a directory (default to pwd)
```

### status

```
Usage:
  tagrity status

List running tagrity processes and the directories being watched
```

### logs

```
Usage:
  tagrity logs

Options:
  [-n=N]                   # the number of log lines to print
                           # Default: 10
  [--debug], [--no-debug]  # if debug logs be printed too

Print the logs for pwd
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RRethy/tagrity. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tagrity project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/RRethy/tagrity/blob/master/CODE_OF_CONDUCT.md).
