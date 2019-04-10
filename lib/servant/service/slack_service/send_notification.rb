module SlackService
  class SendNotification < BaseService
    def process
      TKApi.send_slack_notification(
        body: {
          deal_id: args[:deal_id],
          template: args[:template]
        }
      )
    end
  end
end
