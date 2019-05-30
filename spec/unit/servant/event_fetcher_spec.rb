RSpec.describe Servant::EventFetcher do
  describe "#process" do
    it "return event object" do
      allow_any_instance_of(MockRedis).to receive(:xreadgroup).with(nil).and_return("foo" => %w[bar baz])

      fetcher = Servant::EventFetcher.new(MockRedis.new, nil)
      events = fetcher.process

      expect(events[0].name).to eq("foo")
      expect(events[0].id).to eq("bar")
      expect(events[0].message).to eq("baz")

      expect(events[0].valid?).to be true
    end
  end
end
