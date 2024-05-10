# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019, by Shannon Skipper.
# Copyright, 2024, by Samuel Williams.

require 'async/websocket/adapters/rack'

class Roda
	module RodaPlugins
		# The websockets plugin integrates the async-websocket gem into Roda's
		# routing tree. See the
		# (async-websocket docs)[https://github.com/socketry/async-websocket]
		# for usage details.
		module WebSockets
			module RequestMethods
				ARGS = {}.freeze
				
				def websocket?
					::Async::WebSocket::Adapters::Rack.websocket?(env)
				end
				
				def websocket(args = ARGS, &block)
					return unless websocket?
					
					always do
						halt ::Async::WebSocket::Adapters::Rack.open(env, *args, &block)
					end
				end
			end
		end
		
		register_plugin(:websockets, WebSockets)
	end
end
