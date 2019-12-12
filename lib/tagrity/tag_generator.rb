require 'tagrity/executable_helper'

module Tagrity
  class TagGenerator
    class ExecutableNonExist < StandardError; end

    def initialize
      assert_executables
      @config = ConfigFile.instance
    end

    def generate_all
    end

    def generate(files)
      return if files.empty?
      # TODO assert files and tags writeable
      files
        .select { |file| !dont_index_file(file) }
        .group_by { |file| @config.ft_to_cmd(file.partition('.').last) }
        .each do |cmd, fnames|
        `#{cmd} -f #{tagf} --append #{fnames.join(' ')}`
        puts "{#{cmd}} generated tags for #{fnames} into #{tagf}"
      end
    end

    def delete_files_tags(files)
      return if files.empty?
      # TODO assert file readable
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
