module Tagrity
  class PidFile
    RUN_DIR = "#{__dir__}/../../var/run"

    attr_reader :pid

    def initialize(dir, pid)
      @dir = dir
      @pid = pid
    end

    def name
      "#{@dir.split('/').last}.#{@pid}.pid"
    end

    def contents
      @dir
    end

    class << self
      def write(pid_file)
        File.write("#{run_dir}/#{pid_file.name}", pid_file.contents)
      end

      def delete(dir: nil, pid_file: nil)
        delete_for_dir(dir) if dir
        delete_pid_file(pid_file) if pid_file
      end

      def list(dir: nil)
        Dir.glob("#{run_dir}/*").reduce([]) do |pid_files, path|
          pid = pid_from_path(path)
          pid_file_dir = File.read(path)

          if dir.nil? || File.realdirpath(pid_file_dir) == File.realdirpath(dir)
            if ProcessHelper.alive?(pid)
              pid_files << PidFile.new(pid_file_dir, pid)
            else
              File.delete(path)
            end
          end

          pid_files
        end
      end

      private

      def delete_for_dir(dir)
        pid_file_paths = Dir.glob("#{run_dir}/#{dir.split('/').last}.*.pid").select do |path|
          full_dir = File.read(path)
          File.realdirpath(full_dir) == File.realdirpath(dir)
        end

        pid_file_paths.each do |path|
          File.delete(path)
          ProcessHelper.kill(pid_from_path(path))
        end
      end

      def delete_pid_file(pid_file)
        File.delete(full_path(pid_file.name))
        ProcessHelper.kill(pid_file.pid.to_i)
      end

      def ensure_dirs
        return if @ensure_dirs_done
        FileUtils.mkdir_p(RUN_DIR)
        @ensure_dirs_done = true
      end

      def run_dir
        ensure_dirs
        RUN_DIR
      end

      def full_path(pid_file_name)
        "#{run_dir}/#{pid_file_name}"
      end

      def pid_from_path(pid_file_name)
        pid_file_name.split('.')[-2].to_i
      end
    end
  end
end
