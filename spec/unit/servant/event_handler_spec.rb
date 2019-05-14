RSpec.describe Servant::EventHandler do
  describe "#send" do
    class TestServantEventHandlerFoo < Servant::EventHandler
      def bar
        event
      end
    end

    it "after_intialize with event, message and meta" do
      instance = TestServantEventHandlerFoo.new

      instance.instance_variable_set("@on", "foo")
      instance.instance_variable_set("@request", "message" => { foo: "bar" }, "meta" => { bar: "baz" })
      instance.after_initialize

      expect(instance.send("bar")).to eq("foo")
      expect(instance.event).to eq("foo")
      expect(instance.message).to eq(foo: "bar")
      expect(instance.meta).to eq(bar: "baz")
    end
  end
end
