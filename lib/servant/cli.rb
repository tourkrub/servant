# frozen_string_literal: true

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
    method_option :events, aliases: "-e", required: false

    def start
      begin
        require "#{Dir.pwd}/config/servant.rb"
      rescue LoadError
        nil
      end
      require_relative "../servant"

      trap(:INT) do
        raise Interupt
      end

      prepare_events(options[:events])

      Servant.logger.info("Application started")
      Servant.logger.info("group_id: #{options[:group_id]}, events: #{events}")

      @subscriber = Servant::Subscriber.new(
        group_id: options[:group_id], events: events,
        redis: Application.config.redis
      )

      begin
        @subscriber.process
      rescue Interupt
        @subscriber.stop
      end
    ensure
      Servant.logger.info("Application exited")
    end

    private

    def prepare_events(events = nil)
      @events = !events.nil? ? events.split(",") : Servant::Router::ROUTES.keys
    end

    attr_reader :events
  end
end
