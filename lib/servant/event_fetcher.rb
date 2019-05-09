class EventFetcher
  attr_reader :connection, :args, :event

  def initialize(connection, *args)
    @connection = connection
    @args = args
    @event = nil
  end

  def process
    data = connection.xreadgroup(*args)
    id, message = data.values.flatten
    @event = Servant::Event.new(name: data.keys[0].gsub("event:", ""), id: id, message: message) unless data.empty?
  end
end
