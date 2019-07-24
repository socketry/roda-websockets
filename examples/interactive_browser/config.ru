#!/usr/bin/env -S falcon serve --count 1 --config
# frozen_string_literal: true

require 'roda'

##
# Run this example with `ruby client.rb` or browse to https://localhost:9292.
class App < Roda
  # Roda usually extracts HTML to separate files, but we'll inline it here.
  BODY = <<~HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>WebSockets Example</title>
    </head>
    <body>
      <script>
        const socket = new WebSocket('wss://localhost:9292');
        const min = 2;
        const max = 12;
        const pineapples = Math.floor(Math.random() * (max - min + 1)) + min;
        const status = document.createElement('h1');

        status.innerText = `Eating ${pineapples} pineapples.`;
        document.body.appendChild(status);

        socket.onopen = function() {
          socket.send(JSON.stringify(pineapples));
        };

        socket.onmessage = function(event) {
          status.innerHTML = JSON.parse(event.data);
        };
      </script>
    </body>
    </html>
  HTML

  plugin :websockets

  def on_message(connection, pineapple_count:)
    Async do |task|
      connection.write "Eating #{pineapple_count} pineapples."
      connection.flush

      pineapple_count.downto(1) do |n|
        task.sleep 1
        connection.write '🍍' * n
        connection.flush
      end
      task.sleep 1

      connection.write "Ate #{pineapple_count} pineapples."
      connection.flush
    end
  end

  def messages(connection)
    Enumerator.new do |yielder|
      loop do
        message = connection.read
        break unless message

        yielder << message
      end
    end
  end

  route do |r|
    r.is '' do
      r.websocket do |connection|
        messages(connection).each do |message|
          on_message(connection, pineapple_count: message)
        end
      end

      r.get do
        BODY
      end
    end
  end
end

run App.freeze.app
