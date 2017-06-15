require 'logger'
require "faraday"
require "faraday/curl/version"

module Faraday
  module Curl
    class Middleware < Faraday::Middleware

      def initialize(app, logger = nil, level = nil)
        super(app)
        @logger = logger || ::Logger.new(STDOUT)
        @level = level || :warn
      end

      def call(env)
        command = ['curl', '-v']

        command << "-X #{env[:method].to_s.upcase}"

        if headers = env[:request_headers]
          headers.each do |key, value|
            next if value.nil?
            command << "-H '#{key}: #{quote(value)}'"
          end
        end

        if env[:body].respond_to?(:read)
          command << "-d 'body is a stream, cant render it'"
        elsif env[:body].respond_to?(:to_str)
          command << "-d '#{quote(env[:body].to_str)}'"
        elsif env[:body]
          command << "-d 'body is not string-like, cant render it'"
        end

        command << %Q!"#{env[:url]}"!

        @logger.send( @level, command.join(" "))

        response = @app.call(env)
        response.env[:curl_command] = command
        response
      end

      def quote(value)
        value.to_s.gsub("'", "\\'")
      end
    end
  end
end

Faraday::Request.register_middleware :curl => Faraday::Curl::Middleware
