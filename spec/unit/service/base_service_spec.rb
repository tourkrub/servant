RSpec.describe BaseService do
  describe "#initialize" do
    it "should assign args" do
      service = BaseService.new(foo: :bar)

      expect(service.args).to eq(foo: :bar)
      expect(service.result).to be_nil
    end
  end

  describe "#self.process" do
    class FooService < BaseService
      def process
        set_result(true, "OK")
      end
    end

    it "should set result and return self" do
      service = FooService.process(foo: :bar)

      expect(service.is_a?(FooService)).to be true
      expect(service.result).to eq(success: true, detail: "OK")
      expect(service.success?).to be true
    end

    context "set_result is not called" do
      it "should raise an error" do
        allow_any_instance_of(FooService).to receive(:process).and_return(nil)

        expect { FooService.process }.to raise_error(RuntimeError, "set_result must be called in the end of process")
      end
    end
  end
end
