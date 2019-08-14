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
      Servant.logger.info """
        Processing by #{self.class.name}##{args}
          Meta: #{meta}
          Message: #{message}
      """

      begin
        response = super(args)
      rescue Exception => exception # rubocop:disable Lint/RescueException
        exception_name = exception.class.name.to_s
        raise exception unless exception_handlers.key?(exception_name)

        exception_handlers[exception_name].call(exception)
      end

      metric_name = "Custom/Events/" + event
      increment_matric(metric_name)

      response
    end

    def exception_handlers
      self.class.exception_handlers
    end

    class << self
      def rescue_from(name)
        exception_handlers[name.to_s] = proc { |error|
          yield(error)
        }
      end

      def exception_handlers
        @exception_handlers ||= {}
      end
    end
  end
end
