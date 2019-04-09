require 'httparty'

class TKApi
  include HTTParty
  base_uri ENV.fetch("TK_API_HOST", "localhost:3000/api/legacy")
  logger Servant.logger

  class << self
    def create_deal(options)
      post("/pipedrive/deals", options)
    end

    def send_slack_notification(options)
      post("/slack/send", options)
    end
  end
end
