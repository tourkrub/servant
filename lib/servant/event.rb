class Event
  attr_reader :name, :id, :message

  def initialize(name:, id:, message:)
    @name = name
    @id = id
    @message = message
  end

  def valid?
    !id.nil?
  end
end
