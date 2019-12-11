require 'tagrity/executable_helper'

module Tagrity
  class TagGenerator
    class ExecutableNonExist < StandardError; end

    def initialize(config)
      assert_executables
      @config = config
    end

    def generate_all
    end

    def generate(files)
      files
        .select { |file| !@config.is_ft_excluded(file.partition('.').last) }
        .group_by { |file| @config.ft_to_cmd(file.partition('.').last) }
        .each do |cmd, fnames|
        `#{cmd} -f tags --append #{fnames.join(' ')}`
      end
    end

    def delete_files_tags(files)
      return if files.empty?
      `cat tags | grep -v -F #{files.map { |f| " -e \"	#{f}	\""}.join(' ')} > .tags`
      `mv .tags tags`
    end

    private

    def assert_executables
      %w(cat grep mv).each do |exe|
        if !ExecutableHelper.is_executable(exe)
          raise ExecutableNonExist, "tagrity depends on the executable #{exe}"
        end
      end
    end
  end
end
