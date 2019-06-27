#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

if ARGV.count < 1
  $stderr.puts "please specify a project."
  exit! 1
end

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

project = obs_api.projects.find(ARGV[0])
requests = project.requests

puts "Found #{requests.count} requests:"
puts ""

requests.each do |request|
  puts "##{request.id}, creator: #{request.creator}, state: #{request.state}"
end

