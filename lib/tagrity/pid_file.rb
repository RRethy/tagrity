module Tagrity
  class PidFile
    RUN_DIR = "#{__dir__}/../../var/run"

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

      def delete(dir)
        pid_file_path = Dir.glob("#{run_dir}/#{dir.split('/').last}.*.pid").find do |path|
          full_dir = File.read(path)
          File.realdirpath(full_dir) == File.realdirpath(dir)
        end

        if pid_file_path
          File.delete(pid_file_path)
          pid_file_path.split('.')[-2]
        end
      end

      def list(dir: nil)
        Dir.glob("#{run_dir}/*").reduce([]) do |pid_files, path|
          pid = path.split('.')[-2].to_i
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

      def ensure_dirs
        return if @ensure_dirs_done
        FileUtils.mkdir_p(RUN_DIR)
        @ensure_dirs_done = true
      end

      def run_dir
        ensure_dirs
        RUN_DIR
      end
    end
  end
end
