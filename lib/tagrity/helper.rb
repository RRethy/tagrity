module Tagrity
  class Helper
    root = ENV['TEST'] ? __dir__ : "#{ENV['HOME']}/.tagrity/"
    RUN_DIR = File.join(root, 'var/run').freeze
    LOG_DIR = File.join(root, 'var/log').freeze

    class << self
      def run_dir
        ensure_data_dirs
        RUN_DIR
      end

      def is_executable(cmd)
        !%x{command -v #{cmd}}.empty?
      end

      def kill(pid)
        Process.kill('HUP', pid)
      end

      def alive?(pid)
        Process.kill(0, pid) # signal 0 checks if pid is alive
        true
      rescue Errno::ESRCH
        false
      rescue Errno::EPERM
        true
      end

      private

      def ensure_data_dirs
        FileUtils.mkdir_p(RUN_DIR)
      end
    end
  end
end
