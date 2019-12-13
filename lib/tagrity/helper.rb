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

      def is_executable?(cmd)
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

      def is_git_dir?
        return @is_git_dir unless @is_git_dir.nil?
        `git rev-parse --git-dir &> /dev/null`
        if $?.exitstatus == 0
          @is_git_dir = true
        else
          @is_git_dir = false
        end
      end

      def is_file_ignored?(file)
        `git check-ignore -q #{file} &> /dev/null`
        $?.exitstatus == 0
      end

      def is_file_tracked?(file)
        `git ls-files --error-unmatch #{file} &> /dev/null`
        $?.exitstatus == 0
      end

      private

      def ensure_data_dirs
        FileUtils.mkdir_p(RUN_DIR)
      end
    end
  end
end
