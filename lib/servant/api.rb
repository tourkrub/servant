require 'json'

module Servant
  class Api
    attr_reader :connection

    def initialize(connection: nil)
      @connection = connection || Servant::Application.config.redis
    end

    def list_consumer
      connection.smembers("servant:processors")
    end

    def find_consumer(id)
      {
        id: id,
        group_id: connection.get("servant:#{id}:group_id"),
        events: JSON.parse(connection.get("servant:#{id}:events")),
        processing: connection.get("servant:#{id}:processing").to_i,
        processed: connection.get("servant:#{id}:processed").to_i,
        failed: connection.get("servant:#{id}:failed").to_i
      }
    end
  end
end
