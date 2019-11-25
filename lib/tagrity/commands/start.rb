require 'listen'

module Tagrity
  module Command
    class Start
      def initialize(dir, fg)
        @dir = dir
        @fg = fg
        @options = { latency: 1 }
      end

      def call
        begin
          Process.daemon unless @fg
          listener = Listen.to(
            @dir,
            wait_for_delay: 0.5
          ) do |modified, added, removed|
            puts "modified absolute path: #{modified}"
            puts "added absolute path: #{added}"
            puts "removed absolute path: #{removed}"
          end
          listener.start # not blocking
          puts Process.pid
          sleep
        rescue Interrupt => e
          puts 'ending'
        end
      end
    end
  end
end
