class OrderEvent < BaseEvent
  def created
    PipedriveService::CreateDeal.process(order_id: message["order_id"])
  end
end
