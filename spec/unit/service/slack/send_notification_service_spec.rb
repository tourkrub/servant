RSpec.describe Slack::SendNotificationService do
  describe "#process" do
    it "should set result and return self" do
      allow(TKApi).to receive(:send_slack_notification).with(body: { deal_id: nil, template: nil }).and_return(%w[200 OK])

      service = Slack::SendNotificationService.process

      expect(service.result).to eq(success: true, detail: %w[200 OK])
      expect(service.success?).to be true
    end
  end
end
