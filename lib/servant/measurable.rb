module Servant
  module Measurable
    class << self
      def included(base)
        base.include(InstanceMethod)
      end
    end

    module InstanceMethod
      def increment_matric(metric_name)
        return unless metric_agent

        metric = Servant::Metrics::Increment.new(metric_agent)
        metric.increment(metric_name)
      end

      protected

      def metric_agent
        Servant::Application.config.metrics.agent
      end
    end
  end
end
