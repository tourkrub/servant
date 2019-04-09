require "json"

class BaseEvent
  attr_reader :message

  def initialize(message:)
    @message = JSON.parse(message)
  end

  def send(args)
    Servant.logger.info "Processing by #{self.class.name}##{args}"
    Servant.logger.info "   Message: #{message}"    
    super(args)
  end
end
