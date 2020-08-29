module Tagrity
  module Command
    class Revive
      class << self
        def call
          PidFile.revive_dead_pids
        end
      end
    end
  end
end
