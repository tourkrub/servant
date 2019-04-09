module SlackService
  class SendNotification < BaseService
    def process(deal_id:, template:)
      puts "send a notification for deal_id #{deal_id} using template #{template}"
    end
  end
end
