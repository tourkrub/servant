RSpec.describe Servant::EventHandler do
  describe "#send" do
    class TestServantEventHandlerFoo < Servant::EventHandler
    end

    it "intialize with event, message and meta" do
      instance = TestServantEventHandlerFoo.new(event: "foo", message: "bar", meta: "baz")

      expect(instance.event).to eq("foo")
      expect(instance.message).to eq("bar")
      expect(instance.meta).to eq("baz")
    end
  end
end
