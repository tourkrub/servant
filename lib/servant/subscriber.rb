require 'redis'

module Servant
  class Subscriber
    REDIS_HOST = ENV.fetch('REDIS_HOST', '127.0.0.1').freeze
    
    attr_reader :connection, :channels

    def initialize
      @connection = Redis.new({ host: REDIS_HOST })
      # @channels = []
    end

    # def publish(event: "default", message:)
    #   connection.publish(event, message)
    # end

    # def subscribe(event)
    #   channels.push(event)
    # end

    def process
      trap(:INT) { exit }

      connection.psubscribe("*") do |on|
        on.pmessage do |channel, event, message|
          puts "#{channel} #{event}, #{message}"
          call_event_handler(event, message)
        end
      end
    end
  
  private
    
    def call_event_handler(event, message)
      klass_name, method_name = event.split(".")
      Object.const_get("#{klass_name.capitalize}Event").new(message: message).send(method_name)
    end
  end
  
end
