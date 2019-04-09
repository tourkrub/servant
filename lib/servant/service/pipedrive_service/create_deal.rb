module PipedriveService
  class CreateDeal < BaseService
    def process(order_id:)
      puts "create a deal for order_id #{order_id}"
    end
  end
end
