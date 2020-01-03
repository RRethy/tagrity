require 'cli/ui'

module Tagrity
  module Command
    class Status
      class << self
        def call
          PidFile.alive_pid_files.each do |pid_file|
            puts ::CLI::UI.fmt "{{cyan:#{pid_file.pid}}} {{green:#{pid_file.dir}}}"
          end
        end
      end
    end
  end
end
