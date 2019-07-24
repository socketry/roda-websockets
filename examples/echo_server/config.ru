#!/usr/bin/env -S falcon --count 1 --config
# frozen_string_literal: true

require 'roda'

class App < Roda
  plugin :websockets

  def on_message(connection)
    Async do |task|
      message = connection.read
      task.sleep(3) # Async I/O here
      connection.write(message)
      connection.flush
      connection.close
    end
  end

  route do |r|
    r.is '' do
      r.websocket do |connection|
        on_message(connection).wait
      end
    end
  end
end

run App.freeze.app
