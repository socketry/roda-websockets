# frozen_string_literal: true

require_relative "lib/roda/websockets/version"

Gem::Specification.new do |spec|
	spec.name = "roda-websockets"
	spec.version = Roda::WebSockets::VERSION
	
	spec.summary = "WebSocket integration for Roda"
	spec.authors = ["Shannon Skipper", "Jeffrey Lim", "Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/socketry/roda-websockets"
	
	spec.metadata = {
		"source_code_uri" => "https://github.com/socketry/roda-websockets.git",
	}
	
	spec.files = Dir['{lib}/**/*', '*.md', base: __dir__]
	
	spec.required_ruby_version = ">= 3.1"
	
	spec.add_dependency "async-websocket", "~> 0.12"
	spec.add_dependency "falcon", "~> 0.33"
	spec.add_dependency "roda", "~> 3.0"
end
