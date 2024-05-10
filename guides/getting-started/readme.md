# Getting Started

This guide will help you get started with the `roda-websockets` plugin.

## Installation

Add the gem to your project:

``` sh
$ bundle add roda-websockets
```

## Usage

`roda-websockets` requires that you use [Falcon](https://github.com/socketry/falcon) as your web server in order to establish asynchronous websocket connections.

``` bash
$ falcon serve --count 1
```

`roda-websockets` is a roda plugin, so you need to load it into your roda application similar to other plugins:

``` ruby
class App < Roda
	plugin :websockets
end
```

In your routing block, you can use `r.websocket` to pass the routing to a websocket connection.

``` ruby
r.websocket do |connection|
	# A simple echo server:
	while message = connection.read
		connection.write(message)
	end
end
```
