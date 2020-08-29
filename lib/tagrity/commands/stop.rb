require 'cli/ui'
require 'tagrity/tlogger'
require 'tagrity/provider'

module Tagrity
  module Command
    class Stop
      class << self
        def call(dir)
          pid_files = PidFile.alive_pid_files(dir: dir)
          if pid_files.empty?
            puts ::CLI::UI.fmt "{{red:#{"😕 tagrity doesn't seem to be watching #{dir}"}}}"
          else
            pid_files.each do |pid_file|
              pid_file.delete
              msg = "Successfully killed #{pid_file.pid} for dir #{dir}"
              puts ::CLI::UI.fmt "{{green:#{msg}}}"
              logger.info(msg)
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
