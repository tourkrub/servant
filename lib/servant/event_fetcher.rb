require_relative "event"

module Servant
  class EventFetcher
    attr_reader :connection, :args, :events

    def initialize(connection, *args)
      @connection = connection
      @args = args
      @events = []
    end

    def process
      data = connection.xreadgroup(*args)
      data.each do |key, value|
        id, message = value.flatten
        @events << Servant::Event.new(name: key.gsub("event:", ""), id: id, message: message)
      end
      @events
    end
  end
end
