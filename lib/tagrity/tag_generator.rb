module Tagrity
  class TagGenerator
    def generate_all
    end

    def generate(files)
      return if files.empty?
      `ctags -f tags --append #{files.join(' ')}`
    end

    def delete_files_tags(files)
      return if files.empty?
      `cat tags | grep -v -F #{files.map { |f| " -e \"#{f}\""}.join(' ')} > .tags`
      `mv .tags tags`
    end
  end
end
