# roda-websockets

The roda-websockets gem integrates [async-websockets](https://github.com/socketry/async-websocket) into the [roda](http://roda.jeremyevans.net/) web toolkit. Use this plugin for asynchronous websockets alongside roda and falcon.

[![Development Status](https://github.com/socketry/roda-websockets/workflows/Test/badge.svg)](https://github.com/socketry/roda-websockets/actions?workflow=Test)

## Installation

``` sh
gem install roda-websockets
```

## Source Code

Source code is available on GitHub at
https://github.com/havenwood/roda-websockets

## Usage

roda-websockets requires that you use [Falcon](https://github.com/socketry/falcon) as your web server in order to establish asynchronous websocket connections.

``` ruby
falcon serve --count 1
```

roda-websockets is a roda plugin, so you need to load it into your roda
application similar to other plugins:

``` ruby
class App < Roda
  plugin :websockets
end
```

In your routing block, you can use `r.websocket` to pass the routing
to a websocket connection.

``` ruby
r.websocket do |connection|
  # ...
end
```
