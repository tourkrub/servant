module PipedriveService
  class CreateDeal < BaseService
    def process
      response = TKApi.create_deal(body: {order_id: args[:order_id]})
      set_result(response[0] == "200", response)
    end
  end
end
