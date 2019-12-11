require 'tagrity/tag_generator'
require 'tagrity/config_file'

module Tagrity
  class FileCallbacks
    def initialize
      @tag_generator = TagGenerator.new(ConfigFile.new(nil))
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
