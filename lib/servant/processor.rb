module Servant
  module Processor
    THREADS = [] # rubocop:disable Style/MutableConstant

    class << self
      def add
        THREADS << Thread.new do
          yield
        end
      end

      def start
        THREADS.each(&:join)
      end

      def clean
        THREADS.each(&:kill)
        THREADS.clear
      end
    end
  end
end
