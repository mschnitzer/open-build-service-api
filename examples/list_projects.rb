#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

obs_api.projects.list.each do |project|
  puts "Project: #{project.name}"
end
