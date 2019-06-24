#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

if ARGV.count < 2
  $stderr.puts "please specify a project and a package."
  exit! 1
end

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

project = obs_api.projects.find!(ARGV[0])
package = project.packages.find!(ARGV[1])

puts "title: #{package.title}"
puts "description:\n  #{package.description}"
