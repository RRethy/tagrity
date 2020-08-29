require 'thor'
require 'tagrity/commands/start'
require 'tagrity/commands/stop'
require 'tagrity/commands/status'
require 'tagrity/commands/logs'
require 'tagrity/commands/revive'
require 'tagrity/version'

module Tagrity
  class CLI < Thor
    desc "version", "print tagrity version"
    def version()
      puts Tagrity::VERSION
    end

    desc "start", "Start watching pwd"
    option :fg, type: :boolean, default: false, desc: "keep the tagrity process running in the foreground"
    option :fresh, type: :boolean, default: false, desc: "index the whole codebase before watching the file system. This will be slow if the codebase is large."
    def start()
      Command::Start::call(options['fg'], options['fresh'])
    end

    desc "stop", "Stop watching a directory (default to pwd)"
    option :dir, type: :string, default: Dir.pwd, desc: "directory to stop watching."
    def stop()
      Command::Stop::call(options['dir'])
    end

    desc "status", "List running tagrity processes and the directories being watched"
    def status
      Command::Status::call
    end

    desc "logs", "Print the logs for pwd"
    option :n, type: :numeric, default: 10, desc: "the number of log lines to print"
    option :debug, type: :boolean, default: false, desc: "if debug logs be printed too"
    def logs
      Command::Logs::call(options['n'], options['debug'])
    end

    desc "revive", "Restart any tagrity processes that died"
    def revive
      Command::Revive::call
    end
  end
end
