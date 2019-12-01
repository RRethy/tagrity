module Tagrity
  module Command
    class Status
      class << self
        def call
          PidFile.status.each do |pid_file|
            puts "#{pid_file.pid} #{pid_file.dir}"
          end
        end
      end
    end
  end
end
