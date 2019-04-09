class OrderEvent < BaseEvent
  def created
    PipedriveService::CreateDeal.process(message: message)
  end
end
