require "securerandom"

require_relative "event_fetcher"
require_relative "router"

module Servant
  class Subscriber
    attr_reader :connection, :group_id, :consumer_id, :events, :events_with_namespace, :event_offset, :running

    def initialize(group_id:, consumer_id: nil, events:, redis:)
      @connection = redis
      @group_id = group_id
      @consumer_id = consumer_id || SecureRandom.uuid
      @events = events
      @events_with_namespace = events.map { |e| "event:#{e}" }
      @event_offset = {}

      @events.each do |event|
        init_event_offset(event)
        init_group(event)
      end
      @running = true
    end

    def process
      while running
        fetcher = Servant::EventFetcher.new(connection, group_id, consumer_id,
                                            events_with_namespace, event_offset.values, block: 2000, count: 1)
        fetcher.process

        work(fetcher.event) if fetcher.event&.valid?
      end
    end

    def stop
      @running = false
      Servant.logger.info "Application is being gracefully stopped"
    end

    private

    def work(event)
      Servant.logger.info "Received event - #{event.name}"
      time_start = Time.now.to_f

      Servant::Router.navigate(event.name, event.parsed_message)
    rescue Exception => e # rubocop:disable Lint/RescueException
      Servant.logger.fatal e.class.name
      Servant.logger.fatal e.message
      Servant.logger.fatal e.backtrace
    ensure
      time_diff = (Time.now.to_f - time_start).round(3)
      Servant.logger.info "Completed in #{time_diff}s"
    end

    def init_event_offset(event)
      event_offset[event] = ">"
    end

    def init_group(event)
      connection.xgroup(:create, "event:#{event}", group_id, "$", mkstream: true)
    rescue StandardError
      nil
    ensure
      connection.sadd("events", event)
      connection.sadd("groups", group_id)
    end
  end
end
