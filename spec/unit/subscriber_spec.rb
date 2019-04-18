RSpec.describe Servant::Subscriber do
  describe "#call_event_handler" do
    it "call method from provided constant" do
      class FooEvent < BaseEvent
        def bar
          message["response"]
        end
      end

      dump_message = JSON.dump(response: "OK")
      expect(Servant::Subscriber.new(group_id: "1", events: ["order"]).send(:call_event_handler, "foo.bar", "message" => dump_message)).to eq("OK")
    end
  end
end
