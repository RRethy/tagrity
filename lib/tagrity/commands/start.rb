require 'listen'
require 'tagrity/pid_file'
require 'tagrity/process_helper'

module Tagrity
  module Command
    class Start
      class ErrorAlreadyRunning < StandardError; end

      class << self
        def call(dir, fg)
          unless PidFile.list(dir: dir).empty?
            raise ErrorAlreadyRunning, "Error: tagrity is already watching #{dir}"
          end

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
        rescue ErrorAlreadyRunning => e
          puts e.message
        rescue Interrupt => e
          PidFile.delete(dir)
        end
      end
    end
  end
end
