require 'tagrity/file_callbacks'
require 'tagrity/config_file'
require 'tagrity/tag_generator'

module Tagrity
  class Provider
    class << self
      def provide(want, opts: {})
        case want
        when :file_callbacks
          provide_file_callbacks(opts)
        when :tag_generator
          provide_tag_generator(opts)
        when :config_file
          provide_config_file(opts)
        end
      end

      private

      def provide_file_callbacks(opts: {})
        FileCallbacks.new(provide_tag_generator(opts))
      end

      def provide_tag_generator(opts: {})
        TagGenerator.new(provide_config_file(opts))
      end

      def provide_config_file(opts: {})
        ConfigFile.new(opts[:config_file])
      end
    end
  end
end
