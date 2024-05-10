# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019, by Shannon Skipper.
# Copyright, 2024, by Samuel Williams.

require 'async/websocket/client'
require 'sus/fixtures/async/reactor_context'
require 'sus/fixtures/async/http/server_context'

require 'roda'
require 'roda/websockets'

describe Roda::WebSockets do
	include Sus::Fixtures::Async::ReactorContext
	include Sus::Fixtures::Async::HTTP::ServerContext
	
	let(:roda) do
		Class.new(::Roda).tap do |roda|
			roda.plugin :websockets
			
			roda.route do |r|
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
		end
	end
	
	let(:app) do
		Protocol::Rack::Adapter.new(roda)
	end
	
	it 'supports regular requests' do
		response = client.get('/')
		expect(response.read).to be == 'bar'
	end

	it 'supports websocket requests' do
		Async::WebSocket::Client.connect(client_endpoint) do |connection|
			expect(connection.read).to be == 'zxc'
			expect(connection.read).to be == 'spqr'
			expect(connection.read).to be == 'wombat'
		end
	end
end
