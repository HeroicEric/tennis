require 'bundler'
Bundler.require

require 'net/http'
require 'uri'

def geocode(address)
  address = address.downcase.gsub(/\s+/, '+')
  url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{address}&sensor=false"
  response = Net::HTTP.get(URI.parse(url))

  return JSON.parse(response)
end

# Require Models
Dir.glob("#{Dir.pwd}/models/*.rb") { |m| require "#{m.chomp}" }

# Require Controllers
Dir.glob("#{Dir.pwd}/controllers/*.rb") { |m| require "#{m.chomp}" }

set :haml, { :format => :html5 } # default for Haml format is :xhtml

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/app.db")

# Finalize initialize DB
DataMapper.finalize
DataMapper::auto_upgrade!

get '/' do
  haml :home
end

post '/' do
  @address = geocode(params[:search])

  @lat = @address['results'][0]['geometry']['location']['lat']
  @lng = @address['results'][0]['geometry']['location']['lng']
  @formatted_address = @address['results'][0]['formatted_address']

  haml :home
end
