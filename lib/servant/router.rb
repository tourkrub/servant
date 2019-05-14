require_relative "processor"

module Servant
  module Router
    ROUTES = {} # rubocop:disable Style/MutableConstant

    class << self
      def navigate(route_name, request = {})
        ROUTES[route_name].each do |proc|
          Servant::Processor.add { proc.call(request) }
        end
        Servant::Processor.start
      ensure
        Servant::Processor.clean
      end

      def draw(&block)
        instance_eval(&block)
      end

      private

      def on(name, path: nil, paths: nil)
        paths = [path] if path

        ROUTES[name] = paths.map do |path| # rubocop:disable Lint/ShadowingOuterLocalVariable
          klass_name, action = path.split("#")
          klass = Object.const_get(klass_name)

          proc do |request|
            instance = klass.new
            instance.set_on(name)
            instance.set_request(request)
            instance.after_initialize
            instance.send(action)
          end
        end
      end
    end

    module Routable
      attr_reader :on, :request

      def set_on(on = "")
        @on = on
      end

      def set_request(request = {}) # rubocop:disable Naming/AccessorMethodName
        @request = request
      end

      def after_initialize
        nil
      end
    end
  end
end
