require "json"

module Servant
  class Stats
    attr_reader :id, :group_id, :connection

    def initialize(id:, group_id:, events:, connection:)
      @id = id
      @connection = connection
      @group_id = group_id

      set("group_id", group_id)
      set("events", events)

      connection.lpush("servant:processors", id)
    end

    def incr(key)
      connection.incr("servant:#{id}:#{key}")
    end

    def decr(key)
      connection.decr("servant:#{id}:#{key}")
    end

    def clean
      %w[group_id events processing processed failed].each do |key|
        connection.del("servant:#{id}:#{key}")
      end

      connection.lrem("servant:processors", 0, id)
    end

    def log(event, status = nil)
      connection.lpush("servant:#{status}_logs", JSON.dump(formatted_log(event)))
      connection.ltrim("servant:#{status}_logs", 0, 999)
    end

    private

    def set(key, value)
      connection.set("servant:#{id}:#{key}", value)
    end

    def formatted_log(event)
      {
        consumer_id: id,
        group_id: group_id,
        event: {
          id: event.id,
          name: event.name,
          message: event.parsed_message
        }
      }
    end
  end
end
