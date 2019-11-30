module Tagrity
  module Command
    class Restart
      class << self
        def call(dir, fg)
          Command::Stop.call(dir)
          Command::Start.call(dir, fg)
        end
      end
    end
  end
end
