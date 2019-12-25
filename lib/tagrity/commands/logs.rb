require 'tagrity/tlogger'

module Tagrity
  module Command
    class Logs
      class << self
        def call(n)
          if File.readable?(logf)
            puts `cat #{logf} | tail -n #{Integer(n)}`.split("\n")
          else
            puts "Error: There doesn't seem to be a log file for #{Dir.pwd}"
          end
        end

        private

        def logf
          Tlogger.instance.logf
        end
      end
    end
  end
end
