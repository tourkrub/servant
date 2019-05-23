RSpec.describe Servant::Async do
  before(:all) do
    class TestServantAsyncFoo
      include Servant::Async

      attr_accessor :baz, :foo, :bar
      set_async_methods :method_one, :method_two, :method_three

      def method_one
        @baz
      end

      def method_two
        @baz
      end

      def method_three
        [@baz, @foo, @bar]
      end
    end
  end

  context "Worker" do
    describe "#perform" do
      it "return a correct value" do
        res = TestServantAsyncFooMethodOneWorker.new.perform("TestServantAsyncFoo", "method_one", "@baz" => "baz")

        expect(res).to eq("baz")
      end

      it "return a correct value" do
        res = TestServantAsyncFooMethodTwoWorker.new.perform("TestServantAsyncFoo", "method_two", "@baz" => "baz")

        expect(res).to eq("baz")
      end

      it "return a correct value" do
        res = TestServantAsyncFooMethodTwoWorker.new.perform("TestServantAsyncFoo", "method_three", "@bar"=>"\u0004\bo:\vObject\u0000", "@baz"=>"\u0004\bI\"\bbaz\u0006:\u0006ET", "@foo"=>"\u0004\b{\u0006I\"\bfoo\u0006:\u0006ETI\"\bbar\u0006;\u0000T")

        expect(res[0]).to eq("baz")
        expect(res[1]).to eq({"foo"=>"bar"})
        expect(res[2].is_a?(Object)).to be true
      end      
    end
  end

  context "ClassMethod" do
    describe "#set_async_methods" do
      it "create worker class for this method" do
        expect(Object.const_defined?("TestServantAsyncFooMethodOneWorker")).to be true
        expect(TestServantAsyncFooMethodOneWorker.superclass).to eq(Servant::Async::Worker)
      end

      context "name with underscore" do
        it "create worker class for this method" do
          expect(Object.const_defined?("TestServantAsyncFooMethodTwoWorker")).to be true
          expect(TestServantAsyncFooMethodOneWorker.superclass).to eq(Servant::Async::Worker)
        end
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
          object = Object.new
          instance = TestServantAsyncFoo.new
          instance.baz = "baz"
          instance.foo = {"foo" => "bar"}
          instance.bar = object

          instance.send("method_one")

          expect(TestServantAsyncFooMethodOneWorker.jobs.size).to eq(1)
          expect(TestServantAsyncFooMethodOneWorker.jobs[0]["args"]).to eq(["TestServantAsyncFoo", "method_one", {"@bar"=>"\u0004\bo:\vObject\u0000", "@baz"=>"\u0004\bI\"\bbaz\u0006:\u0006ET", "@foo"=>"\u0004\b{\u0006I\"\bfoo\u0006:\u0006ETI\"\bbar\u0006;\u0000T"}])
        end
      end

      context "async true" do
        it "do nothing" do
          instance = TestServantAsyncFoo.new
          instance.baz = "baz"
          instance.set_async
          res = instance.send("method_one")

          expect(TestServantAsyncFooMethodOneWorker.jobs.size).to eq(0)
          expect(res).to eq("baz")
        end
      end
    end
  end
end
