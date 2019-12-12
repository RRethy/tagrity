require 'tagrity/executable_helper'

module Tagrity
  class TagGenerator
    class ExecutableNonExist < StandardError; end

    def initialize
      assert_executables
      @config = ConfigFile.instance
    end

    def generate(files)
      return if files.empty?
      files
        .select { |file| !dont_index_file(file) && File.readable?(file) }
        .group_by { |file| @config.ft_to_cmd(file.partition('.').last) }
        .each do |cmd, fnames|
        `#{cmd} -f #{tagf} --append #{fnames.join(' ')}`
        if $?.exitstatus != 0
          puts "{#{cmd}} failed to generate tags for #{fnames} into #{tagf}"
        else
          puts "{#{cmd}} generated tags for #{fnames} into #{tagf}"
        end
      end
    end

    def delete_files_tags(files)
      return if files.empty?
      `cat #{tagf} | grep -v -F #{files.map { |f| " -e \"	#{f}	\""}.join(' ')} > .tagrity.tags`
      `mv -f .tagrity.tags #{tagf}`
      puts "Deleted tags for #{files} from #{tagf}"
    end

    private

    def dont_index_file(fname)
      @config.is_ft_excluded(fname.partition('.').last) || @config.is_path_excluded(fname)
    end

    def assert_executables
      %w(cat grep mv).each do |exe|
        if !ExecutableHelper.is_executable(exe)
          raise ExecutableNonExist, "tagrity depends on the executable #{exe}"
        end
      end
    end

    def tagf
      @config.tagf
    end
  end
end
