module SlackService
  class SendNotification < BaseService
    def process
      response = TKApi.send_slack_notification(body: { deal_id: args[:deal_id], template: args[:template] })
      set_result(response[0] == "200", response)
    end
  end
end
