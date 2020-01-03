require 'cli/ui'

module Tagrity
  module Command
    class Status
      class << self
        def call
          PidFile.alive_pid_files.each do |pid_file|
            dir = pid_file.dir
            puts ::CLI::UI.fmt "{{cyan:#{pid_file.pid}}} {{green:#{dir.split('/')[0,dir.length-1].join('/')}/}}{{magenta:#{dir.split('/')[-1]}}}"
          end
        end
      end
    end
  end
end
