#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

if ARGV.count < 1
  $stderr.puts "please specify at least a project and alternatively a package."
  exit! 1
end

project = obs_api.projects.find!(ARGV[0])

if ARGV.count > 1
  package = project.packages.find!(ARGV[1])
  puts package.meta(no_parse: true)
else
  puts project.meta(no_parse: true)
end
