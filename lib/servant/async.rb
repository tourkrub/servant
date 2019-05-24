require "tourkrub/toolkit"

module Servant
  module Async
    class << self
      def included(base)
        const_set("ASYNC_METHODS", [])
        base.include(InstanceMethod)
        base.extend(ClassMethod)
      end
    end

    module InstanceMethod
      def send(method_name, *args, &block)
        if async_method?(method_name) && not_from_agent
          set_agent
          Tourkrub::Toolkit::AsyncMethod::Agent.do_async(self, method_name, *args)
        else
          super
        end
      end

      private

      def set_agent
        instance_variable_set(:@from_agent, true)
      end

      def not_from_agent
        !@from_agent
      end

      def async_method?(method_name)
        self.class.const_get("ASYNC_METHODS").include?(method_name)
      end
    end

    module ClassMethod
      def set_async_methods(*actions) # rubocop:disable Naming/AccessorMethodName
        raise "SidekiqRequired" unless Object.const_defined?("Sidekiq")

        const_set("ASYNC_METHODS", actions.map(&:to_s))

        actions.each do |action|
          agent = Tourkrub::Toolkit::AsyncMethod::Agent.new(new, action.to_s, nil)
          agent.send(:worker)
        end
      end
    end
  end
end
