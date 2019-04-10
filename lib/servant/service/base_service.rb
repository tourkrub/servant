class BaseService
  attr_reader :args, :result

  def initialize(args = nil)
    @args = args
  end

  def self.process(args = nil)
    Servant.logger.info "   Processing by #{name}"
    Servant.logger.info "      Argruments: #{args}"
    service = new(args: args)
    service.process

    raise "set_result must be called in the end of process" unless service.result

    Servant.logger.info "      Result: #{service.result}"
    service
  end

  def set_result(success, detail)
    tap { @result = { success: success, detail: detail } }
  end

  def success?
    result[:success]
  end
end
