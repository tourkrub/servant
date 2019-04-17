# frozen_string_literal: true
require "byebug"
require "thor"

module Servant
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    Interupt = Class.new(StandardError)

    desc "version", "servant version"
    def version
      require_relative "version"
      puts "v#{Servant::VERSION}" # rubocop:disable Rails/Output
    end
    map %w[--version -v] => :version

    desc "start", "start listening process"
    method_option :group_id, aliases: "-g", required: true
    method_option :events, aliases: "-e", required: true

    def start
      require_relative "../servant"

      trap(:INT) do
        raise Interupt
      end

      Servant.logger.info("Application started")
      Servant.logger.info("group_id: #{options[:group_id]}, events: #{options[:events]}")

      @subscriber = Servant::Subscriber.new(group_id: options[:group_id], events: options[:events].split(","))
      
      begin
        @subscriber.process
      rescue Interupt
        @subscriber.stop
      end
    ensure
      Servant.logger.info("Application exited")
    end
  end
end
