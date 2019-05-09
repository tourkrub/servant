RSpec.describe Servant::Subscriber do
  describe "#call_event_handler" do
    it "call method from provided constant" do
      class FooEventHandler < Servant::EventHandler
        def bar
          message["response"]
        end
      end

      dump_message = JSON.dump(response: "OK")
      dump_meta = JSON.dump(type: "text")

      subscriber = Servant::Subscriber.new(redis: MockRedis.new, group_id: "1", events: ["order"])
      response = subscriber.send(:call_event_handler, "foo.bar", "message" => dump_message, "meta" => dump_meta)

      expect(response).to eq("OK")
    end
  end
end
