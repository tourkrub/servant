class BaseService
  def self.process(args)
    Servant.logger.info "Processing by #{self.name}"
    Servant.logger.info "   Argruments: #{args}"
    new.process(args)
  end
end
