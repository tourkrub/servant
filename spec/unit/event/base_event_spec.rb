RSpec.describe BaseEvent do
  describe "#initialize" do
    it "should parse JSON text" do
      dump_json = JSON.dump({foo: :bar})
      event = BaseEvent.new(message: dump_json)

      expect(event.message).to eq({"foo" => "bar"})
    end
  end
end
