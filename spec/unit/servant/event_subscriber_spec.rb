RSpec.describe Servant::Subscriber do
  class TestServantSubscriber < Servant::Subscriber
    private

    def work(event)
      super(event)
      stop
    end
  end

  let(:subscriber) { TestServantSubscriber.new(redis: MockRedis.new, group_id: "foo_1", consumer_id: "bar_1", events: ["foo"]) }

  describe "#initialize" do
    it "return valid object" do
      expect(subscriber.events_with_namespace).to eq(["event:foo"])
      expect(subscriber.event_offset).to eq("foo" => ">")
      expect(subscriber.running).to eq(true)
    end
  end

  describe "#process" do
    before do
      dumped_message = JSON.dump(message: { foo: "bar" }, meta: { bar: "baz" })
      stub_event = Servant::Event.new(id: "foo", name: "foo.bar", message: dumped_message)
      allow_any_instance_of(Servant::EventFetcher).to receive(:process).and_return(true)
      allow_any_instance_of(Servant::EventFetcher).to receive(:event).and_return(stub_event)
    end

    context "without an error" do
      it "fetch and work" do
        allow(Servant::Router).to receive(:navigate).and_return(true)

        expect { subscriber.process }.not_to raise_error
      end
    end

    context "with an error" do
      let(:logger_output) { StringIO.new }

      it "logs an error" do
        allow(Servant).to receive(:logger).and_return(Logger.new(logger_output))
        allow(Servant::Router).to receive(:navigate).and_raise("foobarbaz")

        subscriber.process

        expect(logger_output.string).to include("foobarbaz")
      end
    end
  end

  describe "#stop" do
    it "should set running to false" do
      subscriber.stop

      expect(subscriber.running).to be false
    end
  end
end
