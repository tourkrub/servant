require "redis"

module Servant
  class Subscriber
    REDIS_HOST = ENV.fetch("REDIS_HOST", "127.0.0.1").freeze

    attr_reader :connection, :channels

    def initialize
      @connection = Redis.new(host: REDIS_HOST)
      # @channels = []
    end

    # def publish(event: "default", message:)
    #   connection.publish(event, message)
    # end

    # def subscribe(event)
    #   channels.push(event)
    # end

    def process
      Servant.logger.info("Application started")

      trap(:INT) do
        exit # rubocop:disable Rails/Exit
      end

      connection.psubscribe("*") do |on|
        on.pmessage do |channel, event, message|
          Servant.logger.info "Received event - #{event} from #{channel}"
          time_start = Time.now.to_f
          call_event_handler(event, message)
        rescue Exception => e # rubocop:disable Lint/RescueException
          Servant.logger.fatal e.class.name
          Servant.logger.fatal e.message
          Servant.logger.fatal e.backtrace
        ensure
          time_diff = (Time.now.to_f - time_start).round(3)
          Servant.logger.info "Completed in #{time_diff}s"
        end
      end
    ensure
      Servant.logger.info("Application exited")
    end

    private

    def call_event_handler(event, message)
      klass_name, method_name = event.split(".")
      klass_name = "#{klass_name.capitalize}Event"
      Object.const_get(klass_name).new(message: message).send(method_name)
    end
  end
end
