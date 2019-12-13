require 'tagrity/tag_generator'
require 'tagrity/config_file'

module Tagrity
  class FileCallbacks
    def initialize(tag_generator)
      @tag_generator = tag_generator
    end

    def on_fresh
      @tag_generator.generate_all
    end

    def on_files_modified(files)
      @tag_generator.generate(files)
    end

    def on_files_added(files)
      @tag_generator.generate(files)
    end

    def on_files_removed(files)
      @tag_generator.delete_files_tags(files)
    end
  end
end
