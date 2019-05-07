RSpec.describe Servant::EventHandler do
  describe "#initialize" do
    it "should parse JSON text" do
      dump_json = JSON.dump(foo: :bar)
      event = Servant::EventHandler.new(message: { "message" => dump_json })

      expect(event.message).to eq("foo" => "bar")
    end
  end
end
