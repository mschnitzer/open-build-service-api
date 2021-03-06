#!/usr/bin/ruby
require_relative '../lib/open-build-service-api'

if ARGV.count < 2
  $stderr.puts "please specify a project and a package."
  exit! 1
end

obs_api = OpenBuildServiceAPI::Connection.new(ENV['OBS_USER'], ENV['OBS_PASS'])

project = obs_api.projects.find!(ARGV[0])
package = project.packages.find!(ARGV[1])

destination = Dir.mktmpdir('binary-download-test')

package.binaries.each do |binary_list|
  puts binary_list[:repository]
  binary_list[:binaries].each do |binary|
    binary.download(destination)
    puts "  - #{binary.name} (#{binary.architecture}) (#{binary.size.pretty}) (#{binary.created_at})"
  end
end

puts ""
puts "Saved in: #{destination}"
