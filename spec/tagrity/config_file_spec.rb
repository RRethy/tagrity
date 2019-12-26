require 'tagrity/config_file'

# TODO try reading an invalid config file
# TODO check each value after reading a command
RSpec.describe Tagrity::ConfigFile do
  it 'returns the correct command for the extension' do
    config = Tagrity::ConfigFile.instance
    allow(config)
      .to receive(:extension_commands)
      .and_return({'rb' => 'rb_cmd', 'c' => 'c_cmd'})
    allow(config)
      .to receive(:default_command)
      .and_return('default_cmd')

    { 'rb': 'rb_cmd', 'c': 'c_cmd', 'h': 'default_cmd'}.each do |ext, expected_cmd|
      expect(config.command_for_extension(ext))
        .to eq(expected_cmd)
    end
  end

  it 'ignores blacklisted extensions' do
    config = Tagrity::ConfigFile.instance
    allow(config)
      .to receive(:extensions_whitelist)
      .and_return([])
    allow(config)
      .to receive(:extensions_blacklist)
      .and_return(['rb', 'c'])

    { rb: true, c: true, txt: false }.each do |ext, ignored|
      expect(config.ignore_extension?(ext))
        .to eq(ignored)
    end
  end

  it 'ignores non-whitelisted extensions' do
    config = Tagrity::ConfigFile.instance
    allow(config)
      .to receive(:extensions_whitelist)
      .and_return(['rb', 'c'])
    allow(config)
      .to receive(:extensions_blacklist)
      .and_return([])

    { rb: false, c: false, txt: true }.each do |ext, ignored|
      expect(config.ignore_extension?(ext))
        .to eq(ignored)
    end
  end

  it 'ignores excluded paths' do
    config = Tagrity::ConfigFile.instance
    allow(config)
      .to receive(:excluded_paths)
      .and_return(['foo', 'bar'])

    {
      foo: true,
      fo: false,
      barbar: true,
      foobar: true,
      sbar: false,
      sfoo: false,
      dino: false
    }.each do |path, ignored|
      expect(config.path_ignored?(path))
        .to eq(ignored)
    end
  end

  it 'knows when to respect git' do
    config = Tagrity::ConfigFile.instance

    { 'IGNORED' => true, 'TRACKED' => true, 'NA' => false}.each do |strat, respected|
      allow(config)
        .to receive(:git_strategy)
        .and_return(strat)
      expect(config.respect_git?)
        .to eq(respected)
    end
  end
end
