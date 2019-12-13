require 'thor'
require 'tagrity/commands/start'
require 'tagrity/commands/stop'
require 'tagrity/commands/status'

module Tagrity
  class CLI < Thor
    desc "start", "Start watching a directory (default to pwd)"
    option :dir, desc: "directory to watch (omit to use pwd)"
    option :tagf, desc: "filename (relative) to generate tags into (default: 'tags')."
    option :fg, type: :boolean, desc: "keep the tagrity process running in the foreground"
    option :fresh, type: :boolean, default: false, desc: "index the whole codebase before watching the file system. This will be slow if the codebase is large."
    option :git, type: :boolean, default: true, desc: "only index files which are being tracked by git"
    option :configfile, desc: "See README for more info."
    option :ext_cmds, type: :hash, desc: "which <command> to use to generate tags based on the file extension. <command> must support -f and --append"
    option :default_cmd, desc: "the default <command> to be used to generate tags (default: 'ctags'). <command> must support -f and --append"
    option :excluded_exts, type: :array, desc: "which file extensions to not generate tags for."
    option :excluded_paths, type: :array, desc: "which paths to ignore. Usually better to ignore this since by default only file tracked by git are indexed."
    def start()
      setup_config
      Command::Start::call(dir, fg?, fresh?)
    end

    desc "stop", "Stop watching a directory (default to pwd)"
    option :dir
    def stop()
      Command::Stop::call(dir)
    end

    desc "status", "List running tagrity processes and the directories being watched"
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

    def fresh?
      options[:fresh]
    end

    def setup_config
      ConfigFile.instance.init(
        configfile: options[:configfile],
        default_cmd: options[:default_cmd],
        tagf: options[:tagf],
        ext_cmds: options[:ext_cmds],
        excluded_exts: options[:excluded_exts],
        excluded_paths: options[:excluded_paths],
        git: options[:git]
      )
    end
  end
end
