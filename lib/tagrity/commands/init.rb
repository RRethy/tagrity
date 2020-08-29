module Tagrity
  module Command
    class Init
      class << self
        def call
          PidFile.revive_dead_pids
        end
      end
    end
  end
end
