require "json"

module Servant
  class EventHandler
    attr_reader :event, :message

    def initialize(event:, message:)
      @event = event
      @message = JSON.parse(message["message"])
    end

    def send(args)
      Servant.logger.info "Processing by #{self.class.name}##{args}"
      Servant.logger.info "   Message: #{message}"
      super(args)
    end
  end
end
