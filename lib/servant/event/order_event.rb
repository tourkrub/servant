class OrderEvent < BaseEvent
  def created
    # Pipedrive::CreateDealService.process(order_id: message["order_id"])
  end
end
