class DealEvent < BaseEvent
  def created
    SlackService::SendNotification.process(deal_id: message["deal_id"], template: "check_availability")
  end
end
