RSpec.describe Servant::Publisher do
  describe "#publish" do
    it "return valid response" do
      event_id = Servant::Publisher.client.publish(event: "foo", message: { foo: "bar" }, meta: { bar: "baz" }, correlation_id: "1")

      expect(event_id).not_to be_empty
    end
  end
end
