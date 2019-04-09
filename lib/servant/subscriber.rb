require 'redis'

module Servant
  # class Base
  #   REDIS_HOST = ENV.fetch('REDIS_HOST', '127.0.0.1').freeze
  
  #   attr_reader :connection

  #   def initialize
  #     @connection = Redis.new({ host: REDIS_HOST })
  #   end
  # end

  # class Publisher < Base
  #   def publish(channel: "default", message:)
  #     connection.publish channel, message
  #   end
  # end

  class Subscriber
    REDIS_HOST = ENV.fetch('REDIS_HOST', '127.0.0.1').freeze
    
    attr_reader :connection, :channels

    def initialize
      @connection = Redis.new({ host: REDIS_HOST })
      @channels = []
    end

    def subscribe(channel)
      channels.push channel
    end

    def process
      trap(:INT) { exit }

      connection.psubscribe("*") do |on|
        on.pmessage do |event, channel, message|
          puts "#{event} #{channel}, #{message}"
        end
      end
    end
  end
end
