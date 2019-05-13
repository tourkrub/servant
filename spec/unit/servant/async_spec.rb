RSpec.describe Servant::Async do
  before do
    class TestServantAsyncFoo
      include Servant::Async

      attr_accessor :baz
      set_async_methods :bar

      def bar
        @baz
      end
    end
  end

  context "Worker" do
    describe "#perform" do
      it "return a correct value" do
        res = TestServantAsyncFooBarWorker.new.perform("TestServantAsyncFoo", "bar", "@baz" => "baz")

        expect(res).to eq("baz")
      end
    end
  end

  context "ClassMethod" do
    describe "#set_async_methods" do
      it "create worker class for this method" do
        expect(Object.const_defined?("TestServantAsyncFooBarWorker")).to be true
        expect(TestServantAsyncFooBarWorker.superclass).to eq(Servant::Async::Worker)
      end
    end
  end

  context "InstanceMethod" do
    describe "#set_async" do
      context "val nil" do
        it "return true" do
          instance = TestServantAsyncFoo.new

          expect(instance.set_async).to be true
        end
      end

      context "val false" do
        it "return false" do
          instance = TestServantAsyncFoo.new

          expect(instance.set_async(false)).to be false
        end
      end
    end

    describe "#send" do
      context "async nil" do
        it "create job" do
          instance = TestServantAsyncFoo.new
          instance.baz = "baz"
          instance.send("bar")

          expect(TestServantAsyncFooBarWorker.jobs.size).to eq(1)
          expect(TestServantAsyncFooBarWorker.jobs[0]["args"]).to eq(["TestServantAsyncFoo", "bar", { "@baz" => "baz" }])
        end
      end

      context "async true" do
        it "do nothing" do
          instance = TestServantAsyncFoo.new
          instance.baz = "baz"
          instance.set_async
          res = instance.send("bar")

          expect(TestServantAsyncFooBarWorker.jobs.size).to eq(0)
          expect(res).to eq("baz")
        end
      end
    end
  end
end
