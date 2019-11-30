require 'thor'
require 'tagrity/commands/start'
require 'tagrity/commands/stop'
require 'tagrity/commands/restart'
require 'tagrity/commands/list'

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
      Command::Restart::call(dir, fg)
    end

    desc "list", "list running tagrity processes watching directories"
    def list
      Command::List::call
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
