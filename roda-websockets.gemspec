# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'roda-websockets'
  s.version = '0.1.0'
  s.platform = Gem::Platform::RUBY
  s.license = 'MIT'
  s.summary = 'WebSocket integration for Roda'
  s.description = 'The roda-websockets gem integrates async-websockets into the roda web toolkit.'
  s.author = 'Shannon Skipper'
  s.email = 'shannonskipper@gmail.com'
  s.homepage = 'https://github.com/havenwood/roda-websockets'
  s.files = %w[CHANGELOG.md Gemfile LICENSE Rakefile README.md] + Dir['{spec,lib}/**/*.rb']
  s.add_dependency('async-websocket', '~> 0.12')
  s.add_dependency('falcon', '~> 0.33')
  s.add_dependency('roda', '~> 3.0')
  s.add_development_dependency('minitest', '~> 5.11')
  s.add_development_dependency('minitest-proveit', '~> 1.0')
end
