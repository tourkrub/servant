RSpec.describe BaseEvent do
  describe "#initialize" do
    it "should parse JSON text" do
      dump_json = JSON.dump(foo: :bar)
      event = BaseEvent.new(event: "bar.baz", message: { "message" => dump_json })

      expect(event.event).to eq("bar.baz")
      expect(event.message).to eq("foo" => "bar")
    end
  end
end
