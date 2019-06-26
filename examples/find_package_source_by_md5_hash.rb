#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

if ARGV.count < 2
  $stderr.puts "please specify a project, a package, and a source name."
  exit! 1
end

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

project = obs_api.projects.find!(ARGV[0])
package = project.packages.find!(ARGV[1])

source = package.sources.find_by_md5_hash!(ARGV[2])
puts "#{source} (#{source.size.pretty}) [last modification: #{source.updated_at}] [md5: #{source.md5_hash}]"
