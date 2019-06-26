RSpec.describe Servant::Metrics::Increment do
  let(:agent) { Servant::Metrics::NullStrategy.new }

  subject { described_class.new(agent) }

  it "#increment(metric_name)" do
    expect(agent)
      .to receive(:increment)
      .with("FooBar")

    subject.increment("FooBar")
  end
end
