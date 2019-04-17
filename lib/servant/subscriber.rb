require "byebug"
require "securerandom"
require "redis"

module Servant
  class Subscriber
    REDIS_HOST = ENV.fetch("REDIS_HOST", "127.0.0.1").freeze

    attr_reader :connection, :group_id, :consumer_id, :events, :event_offset, :running

    def initialize(group_id:, consumer_id: nil, events:)
      @connection = Redis.new(host: REDIS_HOST)
      @group_id = group_id
      @consumer_id = consumer_id || SecureRandom.uuid
      @events = events
      @event_offset = {}

      @events.each do |event|
        init_event_offset(event)
        init_group(event)
      end
      @running = true
    end

    def process
      while running do
        fetcher = EventFetcher.new(connection, group_id, consumer_id, events, event_offset.values, block: 2000, count: 1)
        fetcher.process
    
        if fetcher.event
          fetcher.event.valid? ? work(fetcher.event) : reset_event_offset(fetcher.event.name)
        end
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
      call_event_handler(event.name, event.message)
    rescue Exception => e # rubocop:disable Lint/RescueException
      Servant.logger.fatal e.class.name
      Servant.logger.fatal e.message
      Servant.logger.fatal e.backtrace
    ensure
      event_offset[event.name] = event.id
      time_diff = (Time.now.to_f - time_start).round(3)
      Servant.logger.info "Completed in #{time_diff}s"
    end

    def init_event_offset(event)
      event_offset[event] = ">"
    end

    def init_group(event)
      connection.xgroup(:create, event, group_id, '$')
    rescue
      nil
    end

    def call_event_handler(event, message)
      klass_name, method_name = event.split(".")
      klass_name = "#{klass_name.capitalize}Event"
      Object.const_get(klass_name).new(message: message).send(method_name)
    end

    alias_method :reset_event_offset, :init_event_offset
  end

  class EventFetcher
    attr_reader :connection, :args, :event

    def initialize(connection, *args)
      @connection = connection
      @args = args
      @event = nil
    end

    def process
      data = connection.xreadgroup(*args)
      unless data.empty?
        @event = Servant::Event.new(name: data.keys[0], id: data.values.flatten[0], message: data.values.flatten[1])
      end
    end
  end

  class Event
    attr_reader :name, :id, :message

    def initialize(name:, id:, message:)
      @name, @id, @message = name, id, message
    end

    def valid?
      !id.nil?
    end
  end
end
