RSpec.describe Servant do
  it "has a version number" do
    expect(Servant::VERSION).not_to be nil
  end

  it "has redis config" do
    expect(Servant::Application.config.redis).to eq(nil)
  end

  it "has logger" do
    expect(Servant.logger.class).to eq(Logger)
  end
end
