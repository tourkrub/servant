RSpec.describe Servant::EventHandler do
  describe "#initialize" do
    it "should parse JSON text" do
      event = Servant::EventHandler.new(event: "bar.baz", message: { "foo" => "bar" }, meta: { "bar" => "baz" })

      expect(event.event).to eq("bar.baz")
      expect(event.message).to eq("foo" => "bar")
      expect(event.meta).to eq("bar" => "baz")
    end
  end
end
