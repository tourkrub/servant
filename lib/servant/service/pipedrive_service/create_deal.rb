module PipedriveService
  class CreateDeal < BaseService
    def process
      TKApi.create_deal(body: {order_id: args[:order_id]})
    end
  end
end
