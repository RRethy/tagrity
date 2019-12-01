require 'thor'
require 'tagrity/commands/start'
require 'tagrity/commands/stop'
require 'tagrity/commands/restart'
require 'tagrity/commands/status'

module Tagrity
  class CLI < Thor
    desc "start", "Start watching pwd or DIR"
    option :dir
    option :fg, type: :boolean
    def start()
      Command::Start::call(dir, fg?)
    end

    desc "stop", "Stop watching pwd or DIR"
    option :dir
    def stop()
      Command::Stop::call(dir)
    end

    desc "restart", "Stop watching pwd or DIR. Start watching pwd or DIR again"
    option :dir
    option :fg, type: :boolean
    def restart()
      Command::Restart::call(dir, fg?)
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
  end
end
