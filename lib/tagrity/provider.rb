require 'tagrity/file_callbacks'
require 'tagrity/config_file'
require 'tagrity/tag_generator'

module Tagrity
  class Provider
    class << self
      def provide(want)
        case want
        when :file_callbacks
          provide_file_callbacks
        when :tag_generator
          provide_tag_generator
        end
      end

      def provide_file_callbacks
        FileCallbacks.new(provide(:tag_generator))
      end

      def provide_tag_generator
        TagGenerator.new
      end
    end
  end
end
