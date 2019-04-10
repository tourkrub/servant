class DealEvent < BaseEvent
  def created
    service = SlackService::SendNotification.process(deal_id: message["deal_id"], template: "check_availability")
    if service.success?

    else

    end
  end
end
