module Tagrity
  class ExecutableHelper
    class << self
      def is_executable(cmd)
        !%x{command -v #{cmd}}.empty?
      end
    end
  end
end
