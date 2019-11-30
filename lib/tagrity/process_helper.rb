module Tagrity
  class ProcessHelper
    class << self
      def alive?(pid)
        Process.kill(0, pid) # signal 0 checks if pid is alive
        true
      rescue Errno::ESRCH
        false
      rescue Errno::EPERM
        true
      end
    end
  end
end
