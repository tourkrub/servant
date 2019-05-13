module Servant
  class Event
    attr_reader :name, :id, :message

    def initialize(name:, id:, message:)
      @name = name
      @id = id
      @message = message
    end

    def parsed_message
      JSON.parse(message)
    rescue JSON::ParserError
      {}
    end

    def valid?
      !id.nil?
    end
  end
end
