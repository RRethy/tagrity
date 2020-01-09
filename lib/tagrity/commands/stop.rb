require 'cli/ui'
require 'tagrity/tlogger'
require 'tagrity/provider'

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
              logger.info("Successfully killed #{pid_file.pid}")
            end
          end
        end

        def logger
          @logger ||= Provider.provide(:tlogger)
        end
      end
    end
  end
end
