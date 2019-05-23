require "bundler/setup"
require "simplecov"

SimpleCov.minimum_coverage 100
SimpleCov.start do
  add_filter "/spec/"
end

require "mock_redis"
require "servant"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    Sidekiq::Worker.clear_all
    Servant::Application.config.redis = MockRedis.new
  end
end

# monkey patch for MockRedis Stream
# mock_redis-0.20.0/lib/mock_redis/stream.rb:32:in `trim'

class MockRedis
  class Stream
    def trim(count)
      deleted = 0
      if @members.size > count
        deleted = @members.size - count
        @members = @members.to_a[-count..-1].to_set
      end
      deleted
    end
  end
end

require "sidekiq/testing"
