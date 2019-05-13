RSpec.describe Servant::EventHandler do
  describe "#send" do
    class TestServantEventHandlerFoo < Servant::EventHandler
      def bar
        event
      end
    end

    it "intialize with event, message and meta" do
      instance = TestServantEventHandlerFoo.new(event: "foo", message: "bar", meta: "baz")
      
      expect(instance.send("bar")).to eq("foo")
      expect(instance.event).to eq("foo")
      expect(instance.message).to eq("bar")
      expect(instance.meta).to eq("baz")
    end
  end
end
