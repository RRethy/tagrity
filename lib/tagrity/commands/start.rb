require 'listen'
require 'tagrity/pid_file'
require 'tagrity/helper'
require 'tagrity/file_callbacks'
require 'tagrity/provider'

module Tagrity
  module Command
    class Start
      class ErrorProcessAlreadyRunning < StandardError; end

      class << self
        def call(dir, fg, fresh)
          assert_not_running(dir)

          Process.daemon(nochdir: true) unless fg

          callbacks = Provider.provide(:file_callbacks)
          PidFile.write(PidFile.new(dir, Process.pid))

          callbacks.on_fresh if fresh

          listener = Listen.to(
            dir,
            relative: true,
          ) do |modified, added, removed|
            puts "modified absolute path: #{modified}"
            puts "added absolute path: #{added}"
            puts "removed absolute path: #{removed}"
            callbacks.on_files_modified(modified)
            callbacks.on_files_added(added)
            callbacks.on_files_removed(removed)
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
          running_processes = PidFile.alive_pid_files(dir: dir)
          unless running_processes.empty?
            pids = running_processes.map { |pid_file| pid_file.pid }
            raise ErrorProcessAlreadyRunning, "Error: tagrity is already watching #{dir} with process #{pids}"
          end
        end
      end
    end
  end
end
