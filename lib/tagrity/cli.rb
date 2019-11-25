require 'thor'
require 'tagrity/commands/start'

module Tagrity
  class CLI < Thor
    desc "start", "Start watching pwd or DIR"
    option :dir
    option :fg, type: :boolean
    def start()
      Command::Start.new(dir, fg?).call
    end

    desc "stop", "Stop watching pwd or DIR"
    option :dir
    def stop()
      Command::Stop.new(dir).call
    end

    desc "restart", "Stop watching pwd or DIR. Start watching pwd or DIR again"
    option :dir
    option :fg, type: :boolean
    def restart()
      Command::Restart.new(dir).call
    end

    desc "list", "list running tagrity processes watching directories"
    def list
      Command::List.new.call
    end

    private

    def dir
      options[:dir] || Dir.pwd
    end

    def fg?
      options[:fg]
    end
  end
end
