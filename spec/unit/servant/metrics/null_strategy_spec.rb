RSpec.describe Servant::Metrics::NullStrategy do
  it "#increment(*)" do
    expect(subject)
      .to receive(:increment)
      .with(any_args)
      .and_return(nil)

    subject.increment("FooBarBaz")
  end
end
