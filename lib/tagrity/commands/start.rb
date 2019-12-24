require 'listen'
require 'tagrity/pid_file'
require 'tagrity/helper'
require 'tagrity/provider'
require 'tagrity/tlogger'

module Tagrity
  module Command
    class Start
      class ErrorProcessAlreadyRunning < StandardError; end

      class << self
        def call(fg, fresh)
          dir = Dir.pwd
          assert_not_running(dir)

          Process.daemon(nochdir: true) unless fg

          tag_generator = Provider.provide(:tag_generator)
          PidFile.write(PidFile.new(dir, Process.pid))

          logger.fg = fg
          logger.info("Watching #{dir} with process pid #{Process.pid}")

          tag_generator.generate_all if fresh

          listener = Listen.to(
            dir,
            relative: true,
          ) do |modified, added, removed|
            unless modified.empty?
              logger.info("modified absolute path: #{modified}")
              tag_generator.generate(modified)
            end
            unless added.empty?
              logger.info("added absolute path: #{added}")
              tag_generator.generate(added)
            end
            unless removed.empty?
              logger.info("removed absolute path: #{removed}")
              tag_generator.delete_files_tags(removed)
            end
          end
          listener.start
          sleep
        rescue ErrorProcessAlreadyRunning => e
          logger.error(e.message)
        rescue Interrupt => e
          logger.info("Process interrupted. Killing #{Process.pid}")
          PidFile.delete(dir)
        end

        private

        def assert_not_running(dir)
          running_processes = PidFile.alive_pid_files(dir: dir)
          unless running_processes.empty?
            pids = running_processes.map { |pid_file| pid_file.pid }
            raise ErrorProcessAlreadyRunning, "Error: tagrity is already watching #{dir} with process #{pids}"
          end
        end

        def logger
          @logger ||= Tlogger.instance
        end
      end
    end
  end
end
