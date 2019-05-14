RSpec.describe Servant::Event do
  describe "#valid?" do
    it "return valid response" do
      dumped_message = JSON.dump(foo: "bar")
      dumped_meta = JSON.dump(bar: "baz")

      event = Servant::Event.new(id: "foo", name: "bar", message: { "message" => dumped_message, "meta" => dumped_meta })

      expect(event.id).to eq("foo")
      expect(event.name).to eq("bar")
      expect(event.parsed_message).to eq("message" => { "foo" => "bar" }, "meta" => { "bar" => "baz" })

      expect(event.valid?).to be true
    end
  end
end
