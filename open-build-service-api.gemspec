require_relative 'lib/version'

Gem::Specification.new do |s|
  s.name        = 'open-build-service-api'
  s.version     = OpenBuildServiceAPI::VERSION
  s.date        = '2019-06-07'
  s.summary     = 'Library for the Open Build Service API'
  s.description = 'The Open Build Service API wrapped into a Ruby gem.'
  s.authors     = ['Manuel Schnitzer']
  s.email       = 'webmaster@mschnitzer.de'
  s.homepage    = 'https://github.com/mschnitzer/open-build-service-api'
  s.license     = 'MIT'

  s.files       = Dir[
    'lib/**/*.rb',
    '*.md'
  ]

  s.add_dependency 'date', '~> 2.0', '>= 2.0.0'
  s.add_dependency 'nokogiri', '~> 1.10', '>= 1.10.0'

  s.add_development_dependency 'byebug', '~> 11.0', '>= 11.0.1'
end
