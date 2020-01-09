require 'yaml'
require 'singleton'
require 'tagrity/helper'
require 'tagrity/tlogger'
require 'tagrity/provider'

module Tagrity
  class ConfigFile
    include Singleton

    class ErrorTagFileNotWritable < StandardError; end

    CONFIG_FNAME = 'tagrity_config.yml'

    def reload_local
      read_config(fname: local_config_path)
    end

    def reload_global
      read_config(fname: global_config_path)
    end

    def initial_load
      if @config.nil?
        read_config
      end
    end

    def command_for_extension(extension)
      cmd = extension_commands[extension.to_s]
      if cmd.nil?
        default_command
      else
        cmd
      end
    end

    def ignore_extension?(extension)
      unless extensions_whitelist.empty?
        return !extensions_whitelist.include?(extension.to_s)
      end

      extensions_blacklist.include?(extension.to_s)
    end

    def path_ignored?(path)
      excluded_paths.any? { |pat| !(/^#{pat}/ =~ path.to_s).nil? }
    end

    def respect_git?
      git_strategy != 'NA'
    end

    def extension_commands
      @config['extension_commands']
    end

    def default_command
      @config['default_command']
    end

    def tagf
      @config['tagf']
    end

    def extensions_whitelist
      @config['extensions_whitelist']
    end

    def extensions_blacklist
      @config['extensions_blacklist']
    end

    def git_strategy
      @config['git_strategy']
    end

    def excluded_paths
      @config['excluded_paths']
    end

    def to_s
      @config.to_s
    end

    private

    def init
      ensure_extension_commands
      ensure_default_command
      ensure_tagf
      ensure_extensions_whitelist
      ensure_extensions_blacklist
      ensure_git_strategy
      ensure_excluded_paths
    end

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
      ensure_option('extensions_whitelist', [])
    end

    def ensure_extensions_blacklist
      ensure_option('extensions_blacklist', [])
    end

    def ensure_git_strategy
      ensure_option('git_strategy', 'TRACKED')
    end

    def ensure_excluded_paths
      ensure_option('excluded_paths', [])
    end

    def ensure_option(name, default)
      if @config[name].nil? || !@config[name].is_a?(default.class)
        @config[name] = default
      end
    end

    def read_config(fname: nil)
      @config = {}
      config_fname = '{default configuration}'
      if fname.nil?
        if File.readable?(local_config_path)
          config_fname = local_config_path
          @config = YAML.load_file(local_config_path)
        elsif File.readable?(global_config_path)
          config_fname = global_config_path
          @config = YAML.load_file(global_config_path)
        end
      else
        @config = YAML.load_file(fname)
      end
      init
      logger.debug("Loaded config from #{config_fname} with settings #{@config.to_s}")
    end

    def global_config_path
      File.expand_path("#{ENV['XDG_CONFIG_HOME'] || "#{ENV['HOME']}/.config"}/tagrity/#{CONFIG_FNAME}")
    end

    def local_config_path
      File.expand_path("./.#{CONFIG_FNAME}")
    end

    def logger
      @logger ||= Provider.provide(:tlogger)
    end
  end
end
