module Tagrity
  module Command
    class List
      class << self
        def call
          PidFile.list.each do |pid_file|
            puts "#{pid_file.pid} #{pid_file.contents}"
          end
        end
      end
    end
  end
end
