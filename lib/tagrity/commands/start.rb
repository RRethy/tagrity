require 'listen'
require 'tagrity/pid_file'
require 'tagrity/helper'
require 'tagrity/provider'

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

          tag_generator.generate_all if fresh

          listener = Listen.to(
            dir,
            relative: true,
          ) do |modified, added, removed|
            puts "modified absolute path: #{modified}"
            puts "added absolute path: #{added}"
            puts "removed absolute path: #{removed}"
            tag_generator.generate(modified)
            tag_generator.generate(added)
            tag_generator.delete_files_tags(removed)
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
