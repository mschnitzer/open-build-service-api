#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

puts "successfully authenticated"
puts "Last deployment: #{obs_api.about.last_deployment}"
