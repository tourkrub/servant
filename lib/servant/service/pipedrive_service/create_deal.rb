module PipedriveService
  class CreateDeal < BaseService
    def process(order_id:)
      TKApi.create_deal(body: {order_id: order_id})
    end
  end
end
