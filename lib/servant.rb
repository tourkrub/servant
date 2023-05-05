require "logger"
require "dry-configurable"

require_relative "servant/version"
require_relative "servant/subscriber"
require_relative "servant/publisher"
require_relative "servant/router"
require_relative "servant/event_handler"
require_relative "servant/async"
require_relative "servant/metrics/increment"
require_relative "servant/metrics/null_strategy"
require_relative "servant/metrics/new_relic_strategy"

module Servant
  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end

  class Application
    extend Dry::Configurable

    setting :redis, default: nil

    setting :metrics do
      setting :agent, default: nil
    end
  end
end
