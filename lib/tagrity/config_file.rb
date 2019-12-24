require 'yaml'
require 'singleton'
require 'tagrity/helper'

module Tagrity
  class ConfigFile
    include Singleton

    class ErrorTagFileNotWritable < StandardError; end

    CONFIG_FNAME = 'tagrity_config.yml'
    LOCAL_CONFIG_PATH = File.expand_path("./.#{CONFIG_FNAME}")
    GLOBAL_CONFIG_PATH = File.expand_path("#{ENV['XDG_CONFIG_HOME'] || "#{ENV['HOME']}/.config"}/tagrity/#{CONFIG_FNAME}")

    def init
      ensure_extension_commands
      ensure_default_command
      ensure_tagf
      ensure_extensions_whitelist
      ensure_extensions_blacklist
      ensure_git_strategy
      ensure_excluded_paths
    end

    def command_for_extension(extension)
      cmd = extension_commands[extension]
      if cmd.nil?
        default_command
      else
        cmd
      end
    end

    def ignore_extension?(extension)
      unless extensions_whitelist.empty?
        return !extensions_whitelist.include?(extension)
      end

      extensions_blacklist.include?(extension)
    end

    def path_ignored?(path)
      excluded_paths.any? { |pat| /#{pat}/ =~ path }
    end

    def respect_git?
      git_strategy != 'NA'
    end

    def extension_commands
      config['extension_commands']
    end

    def default_command
      config['default_command']
    end

    def tagf
      config['tagf']
    end

    def extensions_whitelist
      config['extensions_whitelist']
    end

    def extensions_blacklist
      config['extensions_blacklist']
    end

    def git_strategy
      config['git_strategy']
    end

    def excluded_paths
      config['excluded_paths']
    end

    def to_s
      config.to_s
    end

    private

    def ensure_extension_commands
      ensure_option('extension_commands', {})
    end

    def ensure_default_command
      ensure_option('default_command', 'ctags')
    end

    def ensure_tagf
      ensure_option('tagf', 'tags')
      if File.exists?(tagf) && !File.writable?(tagf)
        raise ErrorTagFileNotWritable, "#{tagf} must be writable to be used as the tag file."
      end
    end

    def ensure_extensions_whitelist
      ensure_option('whitelist_extensions', [])
    end

    def ensure_extensions_blacklist
      ensure_option('blacklist_extensions', [])
    end

    def ensure_git_strategy
      ensure_option('git_strategy', 'TRACKED')
    end

    def ensure_excluded_paths
      ensure_option('extension_commands', [])
    end

    def ensure_option(name, default)
      if config[name].nil? || !config[name].is_a?(default.class)
        config[name] = default
      end
    end

    def config
      @config ||= read_config
    end

    def read_config
      if File.readable?(LOCAL_CONFIG_PATH)
        @config = YAML.load_file(LOCAL_CONFIG_PATH)
      elsif File.readable?(GLOBAL_CONFIG_PATH)
        @config = YAML.load_file(GLOBAL_CONFIG_PATH)
      else
        @config = {}
      end
    end
  end
end
