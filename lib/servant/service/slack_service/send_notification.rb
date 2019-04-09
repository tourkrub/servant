module SlackService
  class SendNotification < BaseService
    def process(deal_id:, template:)
      puts "send a notification for deal_id #{deal_id} using template #{template}"
      TKApi.send_slack_notification(body: {deal_id: deal_id, template: template})
    end
  end
end
