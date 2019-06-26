module Servant
  module Metrics
    class NullStrategy
      def increment(*); end
    end
  end
end
