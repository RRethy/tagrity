# Tagrity

Automatically regenerate tags on file changes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tagrity'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tagrity

## Usage

```
Commands:
  tagrity help [COMMAND]  # Describe available commands or one specific command
  tagrity start           # Start watching a directory (default to pwd)
  tagrity status          # List running tagrity processes and the directories being watched
  tagrity stop            # Stop watching a directory (default to pwd)
```

### start

```
Usage:
  tagrity start

Options:
  [--dir=DIR]
  [--fg], [--no-fg]
  [--configfile=CONFIGFILE]
  [--tagf=TAGF]
  [--default-cmd=DEFAULT_CMD]
  [--excluded-exts=one two three]
  [--excluded-paths=one two three]

Start watching a directory (default to pwd)
```

### stop

```
Usage:
  tagrity stop

Options:
  [--dir=DIR]

Stop watching a directory (default to pwd)
```

### status

```
Usage:
  tagrity status

List running tagrity processes and the directories being watched
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tagrity. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tagrity project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/tagrity/blob/master/CODE_OF_CONDUCT.md).
