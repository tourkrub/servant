require "redis"

module Servant
  class Publisher
    REDIS_HOST = ENV.fetch("REDIS_HOST", "127.0.0.1").freeze

    attr_reader :connection, :channels

    def initialize
      @connection = Redis.new(host: REDIS_HOST)
    end

    def publish(event:, message:)
      connection.publish(event, JSON.dump(message))
    end

    class << self
      def client
        @client ||= Servant::Publisher.new
      end
    end
  end
end
