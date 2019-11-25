module Tagrity
  module Command
    class Stop
      def initialize(dir)
        @dir = dir
      end

      def call
        puts "called stop #{@dir}"
      end
    end
  end
end
