RSpec.describe Servant::EventFetcher do
  describe "#process" do
    it "return event object" do
      allow_any_instance_of(MockRedis).to receive(:xreadgroup).with(nil).and_return({"foo" => ["bar","baz"]})

      fetcher = Servant::EventFetcher.new(MockRedis.new, nil)
      event = fetcher.process

      expect(event.name).to eq("foo")
      expect(event.id).to eq("bar")
      expect(event.message).to eq("baz")

      expect(event.valid?).to be true
    end
  end
end
