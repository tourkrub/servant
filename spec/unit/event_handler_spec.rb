RSpec.describe Servant::EventHandler do
  describe "#initialize" do
    it "should parse JSON text" do
      dump_json = JSON.dump(foo: :bar)
      event = Servant::EventHandler.new(event: "bar.baz", message: { "message" => dump_json })

      expect(event.event).to eq("bar.baz")
      expect(event.message).to eq("foo" => "bar")
    end
  end
end
