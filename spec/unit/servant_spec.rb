RSpec.describe Servant do
  it "has a version number" do
    expect(Servant::VERSION).not_to be nil
  end

  it "has redis config" do
    expect(Servant::Application.config.redis.class).to eq(MockRedis)
  end

  it "has logger" do
    expect(Servant.logger.class).to eq(Logger)
  end
end
