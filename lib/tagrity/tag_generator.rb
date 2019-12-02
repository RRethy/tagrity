module Tagrity
  class TagGenerator
    def generate_all
    end

    def generate(files)
      `ripper-tags -f tags --append=yes #{files.join(' ')}`
    end

    def delete_files_tags(files)
      `cat tags | grep -v -F #{files.map { |f| " -e \"#{f}\""}.join(' ')} > .tags`
      `mv .tags tags`
    end
  end
end
