require 'tmpdir'
require 'tempfile'
require 'fileutils'
require 'pry'
require 'tagrity/helper'

module Tagrity
  class TagGenerator
    class ExecutableNonExist < StandardError; end

    def initialize
      assert_executables
      @config = ConfigFile.instance
    end

    def generate_all
      if File.exists?(tagf)
        File.delete(tagf)
      end
      if check_git?
        files = `git ls-files 2> /dev/null`.split
      else
        files = `find * 2> /dev/null`.split
      end
      if $?.exitstatus == 0
        generate(files)
      else
        puts "Failed to get a listing of all files under pwd for use with --fresh."
      end
    end

    def generate(files)
      return if files.empty?
      files
        .select { |file| generate_tags?(file) }
        .group_by { |file| @config.ft_to_cmd(file.partition('.').last) }
        .each do |cmd, fnames|
        Tempfile.create do |tmpf|
          IO::write(tmpf.path, fnames.join("\n"))
          system(cmd, '-f', tagf, '--append', '-L', tmpf.path, out: File::NULL)
          if $?.exitstatus == 0
            puts "{#{cmd}} generated tags for #{fnames} into #{tagf}"
          else
            puts "{#{cmd}} failed to generate tags for #{fnames} into #{tagf}"
          end
        end
      end
    end

    def delete_files_tags(files)
      return if files.empty?
      Tempfile.create do |tmpf|
        File.open(tagf) do |f|
          f.each_line do |line|
            unless files.any? { |fname| line.include?("\t#{fname}\t") }
              tmpf.write line
            end
          end
        end
        tmpf.rewind
        FileUtils.mv(tmpf.path, tagf, force: true)
        puts "Deleted tags for #{files} from #{tagf}"
      end
    end

    private

    def generate_tags?(file)
      copacetic_with_git?(file) && indexable?(file)
    end

    def indexable?(file)
      file != tagf && !is_file_excluded(file) && File.readable?(file)
    end

    def copacetic_with_git?(file)
      !(check_git? && !Helper.is_file_tracked?(file))
    end

    def check_git?
      @config.respect_git? && Helper.is_git_dir?
    end

    def is_file_excluded(fname)
      @config.is_ft_excluded(fname.partition('.').last) || @config.is_path_excluded(fname)
    end

    def assert_executables
      %w(cat grep mv).each do |exe|
        if !Helper.is_executable?(exe)
          raise ExecutableNonExist, "tagrity depends on the executable #{exe}"
        end
      end
    end

    def tagf
      @config.tagf
    end
  end
end
