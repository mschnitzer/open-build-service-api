#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

project = obs_api.projects.find('home:mschnitzer')
puts "project '#{project}' has the following packages:"

project.packages.each do |package|
  puts " - #{package}"
end
