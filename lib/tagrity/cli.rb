require 'thor'
require 'tagrity/commands/start'
require 'tagrity/commands/stop'
require 'tagrity/commands/status'

module Tagrity
  class CLI < Thor
    desc "start", "Start watching a directory (default to pwd)"
    option :dir
    option :fg, type: :boolean
    option :configfile
    option :tagf
    option :excluded_exts, type: :array
    option :excluded_paths, type: :array
    def start()
      setup_config
      Command::Start::call(dir, fg?)
    end

    desc "stop", "Stop watching a directory (default to pwd)"
    option :dir
    def stop()
      Command::Stop::call(dir)
    end

    desc "status", "status running tagrity processes watching directories"
    def status
      Command::Status::call
    end

    private

    def dir
      dir = options[:dir] || Dir.pwd
      raise Errno::ENOENT, "No such directory - #{dir}" unless Dir.exists?(dir)
      dir
    end

    def fg?
      options[:fg]
    end

    def setup_config
      ConfigFile.instance.init(
        configfile: options[:configfile],
        default_cmd: options[:default_cmd],
        tagf: options[:tagf],
        excluded_exts: options[:excluded_exts],
        excluded_paths: options[:excluded_paths]
      )
    end
  end
end
