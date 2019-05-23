require "redis"

module Servant
  class Publisher
    attr_reader :connection, :channels

    def initialize(redis:)
      @connection = redis
    end

    def publish(event:, message:, meta: {})
      connection.xadd("event:#{event}", { message: JSON.dump(message), meta: JSON.dump(meta) }, maxlen: 1000)
    end

    class << self
      def client
        @client ||= Servant::Publisher.new(redis: Servant::Application.config.redis)
      end
    end
  end
end
