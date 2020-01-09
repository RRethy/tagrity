require 'tagrity/tlogger'

module Tagrity
  module Command
    class Logs
      class << self
        def call(n, debug)
          if File.readable?(logf)
            system("cat #{logf} | grep -F #{log_levels(debug).map { |lvl| " -e '#{lvl}' " }.join} | tail -n #{Integer(n)}")
          else
            puts "Error: There doesn't seem to be a log file for #{Dir.pwd}"
          end
        end

        private

        def log_levels(debug)
          levels = ['INFO', 'WARN', 'ERROR', 'FATAL', 'UNKNOWN']
          levels << 'DEBUG' if debug
          levels
        end

        def logf
          Tlogger.instance.logf
        end
      end
    end
  end
end
