require 'listen'
require 'tagrity/pid_file'
require 'tagrity/process_helper'

module Tagrity
  module Command
    class Start
      class ErrorProcessAlreadyRunning < StandardError; end

      class << self
        def call(dir, fg)
          assert_not_running(dir)

          Process.daemon unless fg
          PidFile.write(PidFile.new(dir, Process.pid))

          listener = Listen.to(
            dir,
          ) do |modified, added, removed|
            puts "modified absolute paths: #{modified}"
            puts "added absolute paths: #{added}"
            puts "removed absolute paths: #{removed}"
          end
          listener.start
          sleep
        rescue ErrorProcessAlreadyRunning => e
          puts e.message
        rescue Interrupt => e
          PidFile.delete(dir)
        end

        private

        def assert_not_running(dir)
          running_processes = PidFile.status(dir: dir)
          unless running_processes.empty?
            pids = running_processes.map { |pid_file| pid_file.pid }
            raise ErrorProcessAlreadyRunning, "Error: tagrity is already watching #{dir} with process #{pids}"
          end
        end
      end
    end
  end
end
