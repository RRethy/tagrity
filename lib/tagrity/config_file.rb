require 'yaml'
require 'singleton'
require 'tagrity/helper'

module Tagrity
  class ConfigFile
    include Singleton

    class ErrorTagFileNotWritable < StandardError; end
    class ErrorGitNotExecutable < StandardError; end

    def init(
      configfile:,
      default_cmd:,
      tagf:,
      ext_cmds:,
      excluded_exts:,
      excluded_paths:,
      git:
    )
      fname = config_file_name(configfile)
      @config = if fname.nil? then {} else YAML.load_file(fname) end
      ensure_ext_cmds(ext_cmds)
      ensure_default_cmd(default_cmd)
      ensure_tagf(tagf)
      ensure_excluded_exts(excluded_exts)
      ensure_excluded_paths(excluded_paths)
      ensure_git(git)
    end

    def ft_to_cmd(ext)
      ft_cmd = @config['ext_cmds'][ext]
      return @config['default_cmd'] if ft_cmd.nil? || !Helper.is_executable?(ft_cmd)
      ft_cmd
    end

    def is_ft_excluded(ext)
      @config['excluded_exts'].include?(ext)
    end

    def is_path_excluded(path)
      @config['excluded_paths'].any? { |pat| /^(\.\/)?#{pat}.*/ =~ path }
    end

    def tagf
      @config['tagf']
    end

    def respect_git?
      @config['git']
    end

    def to_s
      @config.to_s
    end

    private

    def ensure_ext_cmds(ext_cmds)
      set_option('ext_cmds', ext_cmds, {})
    end

    def ensure_default_cmd(default_cmd)
      set_option('default_cmd', default_cmd, 'ctags')
    end

    def ensure_excluded_exts(excluded_exts)
      set_option('excluded_exts', excluded_exts, [])
    end

    def ensure_excluded_paths(excluded_paths)
      set_option('excluded_paths', excluded_paths, [])
    end

    def ensure_tagf(tagf)
      set_option('tagf', tagf, 'tags')
      if File.exists?(@config['tagf']) && !File.writable?(@config['tagf'])
        raise ErrorTagFileNotWritable, "#{@config['tagf']} must be writable to be used as the tag file."
      end
    end

    def ensure_git(git)
      set_option('git', git, true)
      if @config['git'] && !Helper.is_executable?('git')
        raise ErrorGitNotExecutable, "'git' must be executable to use the --git option."
      end
    end

    def set_option(key, local_val, default)
      unless local_val.nil?
        @config[key] = local_val
      end
      return if @config.key?(key) && !@config[key].nil? && @config[key].is_a?(default.class)
      @config[key] = default
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
      "#{ENV["HOME"]}/.config/tagrity"
    end
  end
end
