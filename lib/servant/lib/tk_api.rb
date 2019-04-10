require 'httparty'

class TKApi
  include HTTParty
  base_uri ENV.fetch("TK_API_HOST", "localhost:3000/api/legacy")
  logger Servant.logger

  class << self
    def render_response(response)
      [response.code, response.message, response.body]
    end

    def create_deal(options)
      render_response(post("/pipedrive/deals", options).response)
    end

    def send_slack_notification(options)
      render_response(post("/slack/send", options).response)
    end
  end
end
