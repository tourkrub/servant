module Servant
  module Async
    class << self
      def included(base)
        base.include(InstanceMethod)
        base.extend(ClassMethod)
      end
    end

    module InstanceMethod
      def send(method_name, *args, &block)
        method_name = method_name.to_s
        async_method = self.class.async_methods[method_name]

        if async_method.is_a?(Hash) && not_from_agent
          set_agent
          Tourkrub::Toolkit::AsyncMethod::Agent.do_async(self, method_name, async_method["queue"], *args)
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
    end

    module ClassMethod
      def set_async_methods(*to_async_methods) # rubocop:disable Naming/AccessorMethodName
        raise "Sidekiq is requried" unless Object.const_defined?("Sidekiq")
        raise "Tourkrub::Toolkit::AsyncMethod is requried" unless Object.const_defined?("Tourkrub::Toolkit::AsyncMethod")

        @async_methods = {}

        to_async_methods.each do |to_async_method|
          action, queue = to_async_method.is_a?(Array) ? to_async_method : [to_async_method, nil]
          action = action.to_s

          @async_methods[action] = { "queue" => queue }

          agent = Tourkrub::Toolkit::AsyncMethod::Agent.new(new, action, queue, nil)
          agent.send(:worker)
        end
      end

      def async_methods
        @async_methods ||= {}
      end
    end
  end
end
