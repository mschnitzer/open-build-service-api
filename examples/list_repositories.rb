#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

if ARGV.count < 1
  $stderr.puts "please specify a project."
  exit! 1
end

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

project = obs_api.projects.find!(ARGV[0])
project.repositories.each do |repo|
  puts "#{repo.name}:"

  repo.paths.each do |path|
    puts "  - #{path[:project]} (#{path[:repository]})"
  end

  repo.architectures.each do |arch|
    puts "  * #{arch}"
  end
end
