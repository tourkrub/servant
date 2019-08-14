require "json"

require_relative "async"
require_relative "router"
require_relative "measurable"

module Servant
  class EventHandler
    include Servant::Async
    include Servant::Router::Routable
    include Servant::Measurable

    attr_reader :event, :message, :meta, :correlation_id

    def after_initialize
      @event = @on
      @message = @request["message"]
      @meta = @request["meta"]
      @correlation_id = @request["correlation_id"]
    end

    def send(args)
      Servant.logger.info """
        Processing by #{self.class.name}##{args}
          Correlation_id: #{correlation_id}
          Meta: #{meta}
          Message: #{message}
      """

      response = super(args)

      metric_name = "Custom/Events/" + event
      increment_matric(metric_name)

      response
    end
  end
end
