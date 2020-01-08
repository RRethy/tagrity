require 'cli/ui'

module Tagrity
  module Command
    class Status
      class << self
        def call
          PidFile.alive_pid_files.each do |pid_file|
            dir_a = pid_file.dir.split('/')
            puts ::CLI::UI.fmt "{{cyan:#{pid_file.pid}}} {{green:#{dir_a[0,dir_a.length-1].join('/')}/}}{{magenta:#{dir_a[-1]}}}"
          end
        end
      end
    end
  end
end
