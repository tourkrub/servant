require "json"

require_relative "async"
require_relative "router"
require_relative "measurable"

module Servant
  class EventHandler
    include Servant::Async
    include Servant::Router::Routable
    include Servant::Measurable

    attr_reader :event, :message, :meta

    def after_initialize
      @event = @on
      @message = @request["message"]
      @meta = @request["meta"]
    end

    def send(args)
      Servant.logger.info "Processing by #{self.class.name}##{args}"
      Servant.logger.info "   Meta: #{meta}"
      Servant.logger.info "   Message: #{message}"

      response = super(args)

      metric_name = "Custom/Events/" + on.split(".").map(&:capitalize).join
      increment_matric(metric_name)

      response
    end
  end
end
