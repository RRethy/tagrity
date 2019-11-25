module Tagrity
  module Command
    class Restart
      def initialize(dir)
        @dir = dir
      end

      def call
        puts "called restart #{@dir}"
      end
    end
  end
end
