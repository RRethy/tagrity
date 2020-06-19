require 'tmpdir'
require 'tempfile'
require 'fileutils'
require 'tagrity/helper'
require 'pry'

module Tagrity
  class TagGenerator
    class ExecutableNonExist < StandardError; end

    def initialize(config, logger)
      @config = config
      @logger = logger
    end

    def generate_all
      if File.exists?(tagf)
        File.delete(tagf)
      end
      cmd = if check_git?
        'git ls-files 2> /dev/null'
      else
        'find * -type f 2> /dev/null'
      end
      files = `#{cmd}`.split("\n")
      if $?.exitstatus == 0
        generate(files)
      else
        @logger.error("Failed to get a listing of all files under pwd for use with --fresh. Used #{cmd}.")
      end
    end

    def generate(files)
      return if files.empty?
      files
        .select { |file| generate_tags?(file)}
        .group_by { |file| @config.command_for_extension(file.split('.').last) }
        .each do |cmd, fnames|
        Tempfile.create do |tmpf|
          IO::write(tmpf.path, fnames.join("\n"))
          system(cmd, '-f', tagf, '--append', '-L', tmpf.path, out: File::NULL, err: File::NULL)
          if $?.exitstatus == 0
            @logger.info("{#{cmd}} generated tags for #{fnames} into #{tagf}")
          else
            @logger.info("{#{cmd}} failed (#{$?.exitstatus}) to generate tags for #{fnames} into #{tagf}")
          end
        end
      end
    end

    def delete_files_tags(files)
      return if files.empty? || !File.readable?(tagf)
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
        @logger.info("Deleted tags for #{files} from #{tagf}")
      end
    end

    private

    def generate_tags?(file)
      copacetic_with_git?(file) && indexable?(file)
    end

    def indexable?(file)
      file != tagf && !file_excluded?(file) && File.readable?(file)
    end

    def copacetic_with_git?(file)
      return true if !check_git?
      case @config.git_strategy
      when 'TRACKED'
        Helper.file_tracked?(file)
      when 'IGNORED'
        !Helper.file_ignored?(file)
      else
        false
      end
    end

    def check_git?
      @check_git ||= @config.respect_git? && Helper.git_dir?
    end

    def file_excluded?(fname)
      @config.ignore_extension?(fname.split('.').last) || @config.path_ignored?(fname)
    end

    def tagf
      @config.tagf
    end
  end
end
