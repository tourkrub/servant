RSpec.describe Servant::Metrics::NewRelicStrategy do
  let(:newrelic) { double("NewRelicAgent") }

  subject  { described_class.new(newrelic) }

  before { allow(newrelic).to receive(:increment_metric) }

  it "#increment(metric_name)" do
    expect(newrelic)
      .to receive(:increment_metric)
      .with("FooBarBaz")

    subject.increment("FooBarBaz")
  end
end
