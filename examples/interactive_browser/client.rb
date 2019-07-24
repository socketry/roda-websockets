# frozen_string_literal: true

require 'async'
require 'async/http/endpoint'
require 'async/websocket/client'

module Client
  URL = 'https://localhost:9292'
  ENDPOINT = Async::HTTP::Endpoint.parse URL
  TIMEOUT = 15
  REPEAT = 3

  module_function

  def call
    Async do |task|
      task.with_timeout TIMEOUT do
        Async::WebSocket::Client.connect ENDPOINT do |connection|
          tasks = REPEAT.times.map do
            task.async do
              pinapple_count = rand 2..12
              puts "Sending message: #{pinapple_count}"
              connection.write pinapple_count
              connection.flush
            end
          end

          while (message = connection.read)
            puts "Receiving message: #{message}"
          end
        rescue Async::TimeoutError
          connection.close
        ensure
          tasks.each(&:stop)
        end
      end
    end
  end
end

Client.call
