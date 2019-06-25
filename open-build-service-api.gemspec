require_relative 'lib/version'

Gem::Specification.new do |s|
  s.name        = 'open-build-service-api'
  s.version     = OpenBuildServiceAPI::VERSION
  s.date        = OpenBuildServiceAPI::RELEASE_DATE
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
  s.add_dependency 'forwardable', '~> 1.2', '>= 1.2.0'
  s.add_dependency 'nokogiri', '~> 1.10', '>= 1.10.0'
  s.add_dependency 'filesize', '~> 0.2', '>= 0.2.0'
  s.add_dependency 'fileutils', '~> 1.2', '>= 1.2.0'

  s.add_development_dependency 'byebug', '~> 11.0', '>= 11.0.1'
  s.add_development_dependency 'rspec', '~> 3.8', '>= 3.8.0'
end
