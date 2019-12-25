require 'singleton'
require 'logger'
require 'tagrity/helper'

module Tagrity
  class Tlogger
    include Singleton

    attr_writer :fg

    def info(msg)
      logger.info(msg)
    end

    def error(msg)
      logger.error(msg)
    end

    def logf
      # TODO this can cause duplicates, unlikely tho
      "#{Helper.log_dir}/#{Dir.pwd.gsub(/\//, '--')}.log"
    end

    private

    def logger
      @logger ||= Logger.new(@fg ? STDOUT : logf, 'weekly')
    end
  end
end
