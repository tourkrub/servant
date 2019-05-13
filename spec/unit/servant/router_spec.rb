RSpec.describe Servant::Router do
  before do
    class TestServantRouterFoo
      include Servant::Router::Routable

      def bar
        Servant.logger.info "baz"
      end
    end

    Servant::Router.draw do
      on "foo", path: "TestServantRouterFoo#bar"
    end

    @stub_foo = TestServantRouterFoo.new
    allow(TestServantRouterFoo).to receive(:new).and_return(@stub_foo)
  end

  describe "#draw" do
    it "add new route" do
      expect(Servant::Router::ROUTES.keys).to include("foo")
    end
  end

  describe "#navigate" do
    it "route to the right method" do
      expect(Servant.logger).to receive(:info).with("baz")
      Servant::Router.navigate("foo", foo: "bar", bar: "baz")

      expect(Servant::Processor::THREADS.size).to eq(0)
      expect(@stub_foo.request).to eq(foo: "bar", bar: "baz")
    end
  end
end
