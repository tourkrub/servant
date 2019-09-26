RSpec.describe Servant::Async do
  before do
    require "tourkrub/toolkit"

    class TestServantAsyncFoo
      include Servant::Async

      set_async_methods %i[method_one low], :method_two

      def initialize(bar = nil, foo = nil, baz = nil)
        @bar = bar
        @foo = foo
        @baz = baz
      end

      def method_one
        @bar
      end

      def method_two
        @foo
      end

      def method_three
        [@bar, @foo, @baz]
      end
    end
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  context "ClassMethod" do
    describe "#set_async_methods" do
      it "create worker class for this method" do
        expect(Object.const_defined?("MethodOneTestServantAsyncFooWorker")).to be true
        expect(MethodOneTestServantAsyncFooWorker.superclass).to eq(Tourkrub::Toolkit::AsyncMethod::Worker)
      end

      context "name with underscore" do
        it "create worker class for this method" do
          expect(Object.const_defined?("MethodTwoTestServantAsyncFooWorker")).to be true
          expect(MethodTwoTestServantAsyncFooWorker.superclass).to eq(Tourkrub::Toolkit::AsyncMethod::Worker)
        end
      end
    end
  end

  describe "#method_three" do
    it "create job in a pool" do
      Sidekiq::Testing.fake! do
        instance = TestServantAsyncFoo.new("bar", "foo", "baz")
        instance.send(:method_one)

        expect(MethodOneTestServantAsyncFooWorker.jobs.size).to eq(1)
        expect(MethodOneTestServantAsyncFooWorker.jobs.first["queue"]).to eq("low")

        instance = TestServantAsyncFoo.new("bar", "foo", "baz")
        instance.send(:method_two)

        expect(MethodTwoTestServantAsyncFooWorker.jobs.size).to eq(1)

        expect(instance.send(:method_three)).to eq(%w[bar foo baz])
      end
    end
  end
end
