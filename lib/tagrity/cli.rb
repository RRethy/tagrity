require 'thor'
require 'tagrity/commands/start'
require 'tagrity/commands/stop'
require 'tagrity/commands/status'

module Tagrity
  class CLI < Thor
    desc "start", "Start watching pwd"
    option :fg, type: :boolean, default: false, desc: "keep the tagrity process running in the foreground"
    option :fresh, type: :boolean, default: false, desc: "index the whole codebase before watching the file system. This will be slow if the codebase is large."
    def start()
      Command::Start::call(options['fg'], options['fresh'])
    end

    desc "stop", "Stop watching pwd"
    def stop()
      Command::Stop::call
    end

    desc "status", "List running tagrity processes and the directories being watched"
    def status
      Command::Status::call
    end
  end
end
