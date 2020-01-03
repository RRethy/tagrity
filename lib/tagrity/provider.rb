require 'tagrity/config_file'
require 'tagrity/tag_generator'
require 'tagrity/tlogger'

module Tagrity
  class Provider
    class << self
      def provide(want)
        case want
        when :tag_generator
          provide_tag_generator
        end
      end

      def provide_tag_generator
        TagGenerator.new(ConfigFile.instance, Tlogger.instance)
      end
    end
  end
end
