require 'logger'

module Servant
  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
