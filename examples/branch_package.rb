#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

source_project = obs_api.projects.find!(ARGV[0])
source_package = ARGV[1]
target_project = obs_api.projects.find!(ARGV[2])
target_package = ARGV[3]

begin
  target_project.branch_package(source_project, source_package, target_package)
rescue OpenBuildServiceAPI::PackageAlreadyExistsError => err
  puts err.message
end
