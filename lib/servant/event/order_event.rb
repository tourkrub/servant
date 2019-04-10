class OrderEvent < BaseEvent
  def created
    service = PipedriveService::CreateDeal.process(order_id: message["order_id"])
    if service.success?

    else

    end
  end
end
