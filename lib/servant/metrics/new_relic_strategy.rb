module Servant
  module Metrics
    class NewRelicStrategy
      attr_reader :newrelic

      def initialize(newrelic)
        @newrelic = newrelic
      end

      def increment(metric_name)
        newrelic.increment_metric(metric_name)
      end
    end
  end
end
