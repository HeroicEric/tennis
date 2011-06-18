require 'rubygems'
require 'bundler'
Bundler.require

require 'net/http'
require 'uri'

# Require Config and Helpers
require_relative 'config/config'
require_relative "helpers"

# Require Models & Controllers
Dir.glob("#{Dir.pwd}/models/*.rb") { |m| require "#{m.chomp}" }
Dir.glob("#{Dir.pwd}/controllers/*.rb") { |m| require "#{m.chomp}" }

get'/hello' do
  "Hello World"
end

get '/' do
  haml :'pages/home'
end

# Search form is submitted on 'home' page
post '/' do
  @instructors = find_instructors(Integer(params[:range]), params[:search])
  @formatted_address = @geo['results'][0]['formatted_address']
  haml :'pages/home'
end
