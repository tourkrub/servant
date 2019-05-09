require "json"

module Servant
  class EventHandler
    attr_reader :event, :message, :meta

    def initialize(event:, message:, meta:)
      @event = event
      @message = message
      @meta = meta
    end

    def send(args)
      Servant.logger.info "Processing by #{self.class.name}##{args}"
      Servant.logger.info "   Meta: #{meta}"
      Servant.logger.info "   Message: #{message}"
      super(args)
    end
  end
end
