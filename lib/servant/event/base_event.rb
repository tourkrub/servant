require "json"

class BaseEvent
  attr_reader :message

  def initialize(message:)
    @message = JSON.parse(message)
  end
end
