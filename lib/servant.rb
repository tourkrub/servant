require "dry-configurable"

require_relative "servant/version"
require_relative "servant/logger"
require_relative "servant/subscriber"
require_relative "servant/publisher"

require_relative "servant/event/base_event"

module Servant
  class Application
    extend Dry::Configurable

    setting :redis, nil
  end
end
