RSpec.describe Pipedrive::CreateDealService do
  describe "#process" do
    it "should set result and return self" do
      allow(TKApi).to receive(:create_deal).with(body: { order_id: nil }).and_return(%w[200 OK])

      service = Pipedrive::CreateDealService.process

      expect(service.result).to eq(success: true, detail: %w[200 OK])
      expect(service.success?).to be true
    end
  end
end
