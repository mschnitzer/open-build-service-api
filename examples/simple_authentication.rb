#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

username = '' # username of your OBS account
password = '' # password of your OBS account

obs_api = OpenBuildServiceAPI::Connection.new(username, password)

puts "successfully authenticated"
puts "Last deployment: #{obs_api.about.last_deployment}"
