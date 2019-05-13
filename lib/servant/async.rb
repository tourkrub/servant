require "sidekiq"

module Servant
  module Async
    class << self
      def included(base)
        base.include(InstanceMethod)
        base.extend(ClassMethod)
      end
    end

    class Worker
      include Sidekiq::Worker

      def perform(klass, name, variables = nil)
        instance = Object.const_get(klass).new

        set_instance_variables(instance, variables)

        instance.set_async
        instance.send(name)
      end

      private

      def set_instance_variables(instance, variables)
        variables&.each { |k, v| instance.instance_variable_set(k, v) }
      end
    end

    module InstanceMethod
      attr_reader :async

      def set_async(val = true) # rubocop:disable Naming/AccessorMethodName
        @async = val
      end

      def send(name, *args)
        if defined_worker?(name) && async.nil?
          jid = worker_class(name).perform_async(self.class.name, name, get_variables)
          Servant.logger.info "JID - #{jid}"
        else
          super(name, *args)
        end
      end

      private

      def get_variables(variables = {})
        instance_variables.inject(variables) do |hash, key|
          hash[key] = instance_variable_get(key)
        end && variables
      end

      def worker_name(action)
        "#{self.class.name}#{action.capitalize}Worker"
      end

      def worker_class(action)
        Object.const_get(worker_name(action))
      end

      def defined_worker?(action)
        Object.const_defined?(worker_name(action))
      end
    end

    module ClassMethod
      def set_async_methods(*actions) # rubocop:disable Naming/AccessorMethodName
        raise "SiskiqRequired" unless Object.const_defined?("Sidekiq")

        actions.each { |action| define_worker(action) }
      end

      private

      def define_worker(action)
        Object.const_set("#{name}#{action.capitalize}Worker", Class.new(Servant::Async::Worker))
      end
    end
  end
end
