module Tagrity
  class PidFile
    RUN_DIR = "#{ENV['HOME']}/.tagrity/var/run"

    class << self
      def write(pid_file)
        File.write("#{run_dir}/#{pid_file.name}", pid_file.dir)
      end

      def delete(dir)
        pid_file_paths = Dir.glob("#{run_dir}/#{dir.split('/').last}.*.pid").select do |path|
          full_dir = File.read(path)
          File.realdirpath(full_dir) == File.realdirpath(dir)
        end

        pid_file_paths.each do |path|
          File.delete(path)
          ProcessHelper.kill(pid_from_path(path))
        end
      end

      def alive_pid_files(dir: nil)
        Dir.glob("#{run_dir}/*").reduce([]) do |pid_files, path|
          pid = pid_from_path(path)
          pid_file_dir = File.read(path)

          if dir.nil? || is_same_dirs(pid_file_dir, dir)
            if ProcessHelper.alive?(pid)
              pid_files << PidFile.new(pid_file_dir, pid)
            else
              File.delete(path)
            end
          end

          pid_files
        end
      end

      def run_dir
        ensure_dirs
        RUN_DIR
      end

      private

      def is_same_dirs(dir1, dir2)
        File.realdirpath(dir1) == File.realdirpath(dir2)
      end

      def ensure_dirs
        return if @ensure_dirs_done
        FileUtils.mkdir_p(RUN_DIR)
        @ensure_dirs_done = true
      end

      def pid_from_path(pid_file_name)
        pid_file_name.split('.')[-2].to_i
      end
    end

    attr_reader :pid, :dir

    def initialize(dir, pid)
      @dir = dir
      @pid = pid
    end

    def ==(other)
      @dir == other.dir
      @pid == other.pid
    end

    def name
      "#{@dir.split('/').last}.#{@pid}.pid"
    end

    def delete
      File.delete(pid_file_path)
      ProcessHelper.kill(pid.to_i)
    end

    private

    def pid_file_path
      "#{PidFile.run_dir}/#{name}"
    end
  end
end
