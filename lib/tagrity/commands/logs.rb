require 'tagrity/tlogger'

module Tagrity
  module Command
    class Logs
      class << self
        def call(n)
          puts `cat #{logf} | tail -n #{Integer(n)}`.split("\n")
        end

        private

        def logf
          Tlogger.instance.logf
        end
      end
    end
  end
end
