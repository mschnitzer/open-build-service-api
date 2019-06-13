require 'cgi'
require 'date'
require 'net/http'
require 'nokogiri'
require_relative 'version'
require_relative 'exception'
require_relative 'connection'

# OBS API
require_relative 'api/about'
require_relative 'api/projects'

# Models
require_relative 'models/package'
require_relative 'models/project'
