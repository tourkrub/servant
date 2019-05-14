require "json"

require_relative "async"
require_relative "router"

module Servant
  class EventHandler
    include Servant::Async
    include Servant::Router::Routable

    attr_reader :event, :message, :meta

    def after_initialize
      @event = @on
      @message = request["message"]
      @meta = request["meta"]
    end

    def send(args)
      Servant.logger.info "Processing by #{self.class.name}##{args}"
      Servant.logger.info "   Meta: #{meta}"
      Servant.logger.info "   Message: #{message}"
      super(args)
    end
  end
end
