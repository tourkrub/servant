require "byebug"
require "securerandom"
require "redis"

module Servant
  class Subscriber
    REDIS_HOST = ENV.fetch("REDIS_HOST", "127.0.0.1").freeze

    attr_reader :connection, :channels

    def initialize
      @connection = Redis.new(host: REDIS_HOST)
      @channels = []
    end

    def process
      Servant.logger.info("Application started")

      trap(:INT) do
        exit # rubocop:disable Rails/Exit
      end

      group_id = "group-1"
      consumer_id = SecureRandom.uuid
      stream_keys = %w(order.created deal.created).freeze
      @last_ids = {}

      stream_keys.each do |key|
        @last_ids[key] = ">"
        connection.xgroup(:create, key, group_id, '$')
      rescue
        nil
      end

      while true do
        event = connection.xreadgroup(group_id, consumer_id, stream_keys, @last_ids.values, block: 100000)

        if event.empty?
          next
        end

        event_name = event.keys[0]

        if event.values[0].empty?
          @last_ids[event_name] =  ">"
          next
        end
        
        event_id, message = event[event_name][0][0], event[event_name][0][1]["message"]

        begin
          Servant.logger.info "Received event - #{event_name}"
          time_start = Time.now.to_f
          sleep(rand(0.1...0.9))
          call_event_handler(event_name, message)
        rescue Exception => e # rubocop:disable Lint/RescueException
          Servant.logger.fatal e.class.name
          Servant.logger.fatal e.message
          Servant.logger.fatal e.backtrace
        ensure
          @last_ids[event_name] = event_id

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
