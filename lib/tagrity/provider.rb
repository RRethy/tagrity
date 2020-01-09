require 'tagrity/config_file'
require 'tagrity/tag_generator'
require 'tagrity/tlogger'

module Tagrity
  class Provider
    class << self
      def provide(want)
        case want
        when :tag_generator
          TagGenerator.new(provide(:config_file), provide(:tlogger))
        when :tlogger
          Tlogger.instance
        when :config_file
          config = ConfigFile.instance
          config.initial_load
          config
        end
      end
    end
  end
end
