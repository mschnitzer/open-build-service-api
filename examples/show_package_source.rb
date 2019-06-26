#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

if ARGV.count < 3
  $stderr.puts "please specify a project, a package, and a source name."
  exit! 1
end

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

project = obs_api.projects.find!(ARGV[0])
package = project.packages.find!(ARGV[1])

source = package.sources.find!(ARGV[2])
puts source.content
