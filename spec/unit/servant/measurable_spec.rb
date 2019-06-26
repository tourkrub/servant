RSpec.describe Servant::Measurable do
  class TestServantMeasurableFoo
    include Servant::Measurable

    def do_something
      increment_matric("Something/Tracked")
    end
  end

  let(:metric_increment) { double("Increment") }
  let(:null_agent) { double("NullAgent") }

  before do
    allow(metric_increment)
      .to receive(:increment)
      .with(any_args)

    allow(Servant::Metrics::Increment)
      .to receive(:new)
      .and_return(metric_increment)

    allow(Servant::Application)
      .to receive_message_chain(:config, :metrics, :agent)
      .and_return(null_agent)
  end

  context "InstanceMethod" do
    it "#increment_matric(metric_name)" do
      instance = TestServantMeasurableFoo.new

      expect(metric_increment)
        .to receive(:increment)
        .with("Something/Tracked")

      instance.do_something
    end
  end
end
