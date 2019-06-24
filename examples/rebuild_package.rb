#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

if ARGV.size < 2
  puts "please specify a project and a package"
  exit! 1
end

project = obs_api.projects.find!(ARGV[0])
package = project.packages.find!(ARGV[1])

repo = ARGV[2]
arch = ARGV[3]

package.rebuild!(repo, arch)

puts "rebuild triggered"
