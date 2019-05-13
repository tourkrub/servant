RSpec.describe Servant::Processor do
  before do
    Servant::Processor.clean
  end

  describe "#add" do
    it "call method from provided constant" do
      Servant::Processor.add { proc { "foo" } }

      expect(Servant::Processor::THREADS.size).to eq(1)

      Servant::Processor.add { proc { "bar" } }

      expect(Servant::Processor::THREADS.size).to eq(2)
    end
  end

  describe "#start" do
    it "running threads" do
      @count = 0

      Servant::Processor.add { @count += 1 }
      Servant::Processor.start

      expect(@count).to eq(1)
    end
  end

  describe "#clean" do
    it "kill threads and clear threads" do
      Servant::Processor.add { proc { "foo" } }
      Servant::Processor.clean

      expect(Servant::Processor::THREADS.size).to eq(0)
    end
  end
end
