module Tagrity
  class TagGenerator
    class ExecutableNonExist < StandardError; end

    def initialize
      assert_executables
    end

    def generate_all
    end

    def generate(files)
      return if files.empty?
      `ripper-tags -f tags --append #{files.join(' ')}`
    end

    def delete_files_tags(files)
      return if files.empty?
      `cat tags | grep -v -F #{files.map { |f| " -e \"#{f}\""}.join(' ')} > .tags`
      `mv .tags tags`
    end

    private

    def assert_executables
      %w(cat grep mv).each do |exe|
        if %x{command -v #{exe}}.empty?
          raise ExecutableNonExist, "tagrity depends on the executable #{exe}"
        end
      end
    end
  end
end
