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

That's it! It will monitor pwd and index any files which change. Check out [Configuration](#configuration) to restrict which files get indexed.

To stop watching pwd, use

```sh
tagrity stop
```

To view directories being watched, use

```sh
tagrity status
```

## Configuration

Configuration can be done through use of a `tagrity_config.yml` file that looks like the following:

**NOTE:** Tagrity will look for a global config file at `$XDG_CONFIG_HOME/tagrity/tagrity_config.yml` (usually this will be `~/.config/tagrity/tagrity_config.yml`). This can be overridden by a local config in the current directory under the name `.tagrity_config.yml`.

**NOTE:** Tagrity needs to be restarted for configuration changes to take effect.

[`tagrity_config.yml`](https://github.com/RRethy/tagrity/blob/master/sample_config.yml)

```yaml
# which command to use to generate tags for a specific file extension
# overrides default_command
# tag generation commands must support --append, -f, -L
# NOTE: Exuberant-ctags does NOT satisfy this, instead use Universal-ctags
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

# how to integrate with git
# git_strategy: TRACKED | IGNORED | NA
# TRACKED: only index files tracked by git
# IGNORED: only index files which are not ignored by git
# NA: don't use git, index all files under pwd
#
# Default: NA
git_strategy: IGNORED

# which paths (relative to pwd) to ignore
# It's usually better to avoid this since tagrity integrates with git by
# default using the strategy specified by git_strategy
#
# Default: []
excluded_paths: [vendor, node_modules]
```

## Usage

```
Commands:
  tagrity help [COMMAND]  # Describe available commands or one specific command
  tagrity logs            # Print the logs for pwd
  tagrity start           # Start watching pwd
  tagrity status          # List running tagrity processes and the directories being watched
  tagrity stop            # Stop watching pwd
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

Stop watching pwd
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
  [-n=N]  # the number of log lines to print
          # Default: 10

Print the logs for pwd
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RRethy/tagrity. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tagrity project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/RRethy/tagrity/blob/master/CODE_OF_CONDUCT.md).
