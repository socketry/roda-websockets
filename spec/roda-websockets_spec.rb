# frozen_string_literal: true

require 'async'
require 'async/debug/selector'
require 'async/http/endpoint'
require 'async/websocket/client'
require 'falcon/adapters/rack'
require 'falcon/server'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/proveit'
require 'roda'

describe 'roda-websockets plugin' do
  prove_it!

  let :reactor do
    Async::Reactor.new(selector: Async::Debug::Selector.new)
  end

  let :endpoint do
    Async::HTTP::Endpoint.parse('http://localhost:7050')
  end

  let :app do
    app = Class.new(Roda)
    app.plugin :websockets
    app.route do |r|
      r.root do
        r.websocket do |connection|
          %w[zxc spqr wombat].each do |message|
            connection.write(message)
            connection.flush
          end

          connection.close
        end

        'bar'
      end
    end

    app
  end

  let :server do
    Falcon::Server.new(Falcon::Server.middleware(app), endpoint)
  end

  let :client do
    Async::HTTP::Client.new(endpoint)
  end

  before do
    @server_task = reactor.async do
      server.run
    end
  end

  after do
    @server_task.stop
  end

  it 'supports regular requests' do
    reactor.run do
      response = client.get('/')
      assert_equal response.read, 'bar'

      client.close
      reactor.stop
    end
  end

  it 'supports websocket requests' do
    reactor.run do
      Async::WebSocket::Client.connect(endpoint) do |connection|
        assert_equal(connection.read, 'zxc')
        assert_equal(connection.read, 'spqr')
        assert_equal(connection.read, 'wombat')
      end

      reactor.stop
    end
  end
end
