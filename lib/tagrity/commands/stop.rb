module Tagrity
  module Command
    class Stop
      class << self
        def call(dir)
          pid_files = PidFile.list(dir: dir)
          if pid_files.empty?
            puts "😕 tagrity doesn't seem to be watching #{dir}"
          else
            pid_files.each do |pid_file|
              PidFile.delete(pid_file: pid_file)
              puts "Successfully killed #{pid_file.pid}"
            end
          end
        end
      end
    end
  end
end
