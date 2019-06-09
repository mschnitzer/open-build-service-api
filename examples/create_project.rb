#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

if ARGV.empty?
  $stderr.puts 'please provide a project name.'
  exit! 1
end

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

t = obs_api.projects.create(ARGV[0])
puts t.name
