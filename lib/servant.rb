require "logger"
require "dry-configurable"

require_relative "servant/version"
require_relative "servant/subscriber"
require_relative "servant/publisher"
require_relative "servant/router"
require_relative "servant/event_handler"
require_relative "servant/async"

module Servant
  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end

  class Application
    extend Dry::Configurable

    setting :redis, nil
  end
end
