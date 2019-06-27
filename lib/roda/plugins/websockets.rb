# frozen-string-literal: true

require 'async/websocket/adapters/rack'

class Roda
  module RodaPlugins
    # The websockets plugin integrates the async-websocket gem into Roda's
    # routing tree. See the
    # {async-websocket docs}[https://github.com/socketry/async-websocket]
    # for usage details.
    #
    # The following example is an echo server that sleeps one second after
    # receiving a message before echoing that same message back to the client
    # and closing the connection:
    #
    #   plugin :websockets
    #
    #   def messages(connection)
    #     Enumerator.new do |yielder|
    #       while (message = connection.read)
    #         yielder << message
    #       end
    #     end
    #   end
    #
    #   def on_message(connection, message:)
    #     Async do |task|
    #       task.sleep(1)
    #       connection.write(message)
    #       connection.flush
    #       connection.close
    #     end
    #   end
    #
    #   route do |r|
    #     r.root do
    #       r.websocket do |connection|
    #         messages(connection).each do |message|
    #           on_message(connection, message: message)
    #         end
    #       end
    #     end
    #   end
    module WebSockets
      module RequestMethods
        ARGS = {}.freeze

        def websocket?
          Async::WebSocket::Adapters::Rack.websocket?(env)
        end

        def websocket(args = ARGS, &block)
          return unless websocket?

          always do
            halt Async::WebSocket::Adapters::Rack.open(env, *args, &block)
          end
        end
      end
    end

    register_plugin(:websockets, WebSockets)
  end
end
