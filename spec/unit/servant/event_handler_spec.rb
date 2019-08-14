RSpec.describe Servant::EventHandler do
  context "tourkrub-toolkit is not installed" do
    describe "define an EventHandler with set_async_methods" do
      it "should raise error" do
        allow(Object).to receive(:const_defined?).with("Sidekiq").and_return(true)
        allow(Object).to receive(:const_defined?).with("Tourkrub::Toolkit::AsyncMethod").and_return(false)

        expect  do
          class TestServantEventHandlerBar < Servant::EventHandler
            set_async_methods :bar

            def bar
              event
            end
          end
        end.to raise_error("Tourkrub::Toolkit::AsyncMethod is requried")
      end
    end
  end

  context "tourkrub-toolkit is installed" do
    before do
      require "tourkrub/toolkit"

      class TestServantEventHandlerFoo < Servant::EventHandler
        set_async_methods :foo
        rescue_from RuntimeError do
          "rescued"
        end

        def bar
          event
        end

        def foo
          event
        end

        def baz
          raise "should raise"
        end

        def bazbaz
          raise StandardError, "should raise"
        end
      end
    end

    describe "#send" do
      it "after_intialize with event, message and meta" do
        instance = TestServantEventHandlerFoo.new

        instance.instance_variable_set("@on", "foo")
        instance.instance_variable_set("@request", "message" => { foo: "bar" }, "meta" => { bar: "baz" })
        instance.after_initialize

        expect(instance.send("bar")).to eq("foo")
        expect(instance.event).to eq("foo")
        expect(instance.message).to eq(foo: "bar")
        expect(instance.meta).to eq(bar: "baz")

        instance.send("foo")

        expect(FooTestServantEventHandlerFooWorker.jobs.size).to eq(1)
      end

      it "track metrics" do
        instance = TestServantEventHandlerFoo.new

        allow(instance)
          .to receive(:metric_agent)
          .and_return(Servant::Metrics::NullStrategy.new)

        expect(instance)
          .to receive(:increment_matric)
          .with("Custom/Events/bar")

        instance.instance_variable_set("@event", "bar")
        instance.send("bar")
      end
    end

    describe "#rescue_from" do
      it "rescue" do
        instance = TestServantEventHandlerFoo.new

        instance.instance_variable_set("@on", "baz")
        instance.instance_variable_set("@request", "message" => { foo: "bar" }, "meta" => { bar: "baz" })
        instance.after_initialize

        expect { instance.send("baz") }.not_to raise_error(RuntimeError)
      end

      it "not rescue" do
        instance = TestServantEventHandlerFoo.new

        instance.instance_variable_set("@on", "bazbaz")
        instance.instance_variable_set("@request", "message" => { foo: "bar" }, "meta" => { bar: "baz" })
        instance.after_initialize

        expect { instance.send("bazbaz") }.to raise_error(StandardError)
      end
    end
  end
end
