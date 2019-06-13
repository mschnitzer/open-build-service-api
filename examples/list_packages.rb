#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

if ARGV.size < 1
  puts "please specify a project"
  exit! 1
end

project = obs_api.projects.find!(ARGV[0])

project.packages.each do |package|
  puts " - #{package.name}"
end
