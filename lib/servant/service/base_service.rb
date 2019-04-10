class BaseService
  attr_reader :args
  attr_accessor :result

  def initialize(args)
    @args = args
  end

  def self.process(args)
    Servant.logger.info "   Processing by #{self.name}"
    Servant.logger.info "     Argruments: #{args}"
    result = new(args: args).process
    Servant.logger.info "     Result: #{result}"
  end
end
