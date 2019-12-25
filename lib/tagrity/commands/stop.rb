require 'cli/ui'
require 'tagrity/tlogger'

module Tagrity
  module Command
    class Stop
      class << self
        def call
          dir = Dir.pwd
          pid_files = PidFile.alive_pid_files(dir: dir)
          if pid_files.empty?
            puts ::CLI::UI.fmt "{{red:#{"😕 tagrity doesn't seem to be watching #{dir}"}}}"
          else
            pid_files.each do |pid_file|
              pid_file.delete
              puts ::CLI::UI.fmt "{{green:#{"Successfully killed #{pid_file.pid}"}}}"
              Tlogger.instance.info("Successfully killed #{pid_file.pid}")
            end
          end
        end
      end
    end
  end
end
