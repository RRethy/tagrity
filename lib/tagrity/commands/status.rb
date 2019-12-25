require 'cli/ui'

module Tagrity
  module Command
    class Status
      class << self
        def call
          pid_files = PidFile.alive_pid_files.each do |pid_file|
            pid_file
          end

          max_pid_len = pid_files.max do |a, b|
            a.pid.digits.count <=> b.pid.digits.count
          end.pid.digits.count
          max_dir_len = pid_files.max do |a, b|
            a.dir.length <=> b.dir.length
          end.dir.length

          pid_files.each do |pid_file|
            puts ::CLI::UI.fmt "{{cyan:#{pid_file.pid.to_s.ljust(max_pid_len)}}} {{green:#{pid_file.dir.ljust(max_dir_len)}}}"
          end
        end
      end
    end
  end
end
