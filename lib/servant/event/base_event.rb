class BaseEvent
  attr_reader :message

  def initialize(message:)
    @message = message
  end
end

require_relative "order_event"
