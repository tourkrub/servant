RSpec.describe Servant::Event do
  describe "#valid?" do
    it "return valid response" do
      event = Servant::Event.new(id: "foo", name: "bar", message: "baz")

      expect(event.id).to eq("foo")
      expect(event.name).to eq("bar")
      expect(event.message).to eq("baz")

      expect(event.valid?).to be true
    end
  end
end
