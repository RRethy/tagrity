require 'yaml'
require 'tagrity/executable_helper'

module Tagrity
  class ConfigFile
    def initialize(fname)
      fname = config_file_name(fname)
      @config = if fname.nil? then {} else YAML.load_file(fname) end
      ensure_language_cmds
      ensure_default_cmd
      ensure_excluded_fts
    end

    def ft_to_cmd(ext)
      ft_cmd = @config[:language_cmds][ext]
      return @config[:default_cmd] if ft_cmd.nil? || !ExecutableHelper.is_executable(ft_cmd)
      ft_cmd
    end

    def is_ft_excluded(ext)
      @config[:excluded_fts].include?(ext)
    end

    private

    def ensure_language_cmds
      return if @config.key?(:language_cmds) && @config[:language_cmds].is_a?(Hash)
      @config[:language_cmds] = {}
    end

    def ensure_default_cmd
      return if @config.key?(:default_cmd) && @config[:default_cmd].is_a?(String)
      @config[:default_cmd] = 'ctags'
    end

    def ensure_excluded_fts
      return if @config.key?(:excluded_fts) && @config[:excluded_fts].is_a?(Array)
      @config[:excluded_fts] = []
    end

    def config_file_name(fname)
      return fname unless fname.nil?
      return global_config_file_name if File.file?(global_config_file_name)
      nil
    end

    def global_config_file_name
      "#{global_config_dir_name}/config.yml"
    end

    def global_config_dir_name
      "#{$HOME}/.config/tagrity"
    end
  end
end
