module Servant
  module Metrics
    class Increment
      attr_reader :agent

      def initialize(agent)
        @agent = agent
      end

      def increment(metric_name) # rubocop:disable Rails/Delegate
        agent.increment(metric_name)
      end
    end
  end
end
