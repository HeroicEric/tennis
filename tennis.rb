require 'rubygems'
require 'bundler'
Bundler.require

require 'net/http'
require 'uri'

# Set DM logger location and level
DataMapper::Logger.new("log/dm.log", :debug)

def geocode(address)
  address = address.downcase.gsub(/\s+/, '+')
  url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{address}&sensor=false"
  response = Net::HTTP.get(URI.parse(url))

  return JSON.parse(response)
end

def dist_to_lat(dist)
  dist / 69.11
end

def dist_to_lng(dist, lat)
  dist / ( 69.11 * Math.cos(lat) )
end

def radians(degrees)
  degrees * Math::PI / 180
end

def get_bounds(dist, lat, lng)
  bounds = Hash.new

  bounds['lngLeft'] = lng + dist / ( Math.cos( radians(lat) ) * 69.11 ).abs
  bounds['lngRight'] = lng - dist / ( Math.cos( radians(lat) ) * 69.11 ).abs
  bounds['latTop'] = lat + ( dist/69.11 )
  bounds['latBottom'] = lat - ( dist/69.11 )

  bounds
end

def find_instructors(dist, location)
  @geo = geocode(location)
  @lat = @geo['results'][0]['geometry']['location']['lat']
  @lng = @geo['results'][0]['geometry']['location']['lng']
  @bounds = get_bounds(dist, @lat, @lng)

  instructors = Instructor.all(
    :lat.lt => @bounds['latTop'],
    :lat.gt => @bounds['latBottom'],
    :lng.gt => @bounds['lngRight'],
    :lng.lt => @bounds['lngLeft']
  )

  instructors
end

# Require Models
Dir.glob("#{Dir.pwd}/models/*.rb") { |m| require "#{m.chomp}" }

# Require Controllers
Dir.glob("#{Dir.pwd}/controllers/*.rb") { |m| require "#{m.chomp}" }

set :haml, { :format => :html5 } # default for Haml format is :xhtml

configure :development do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/tennis.db")
end

configure :test do
  DataMapper.setup(:default,"sqlite::memory:")
end

# Finalize initialize DB
DataMapper.finalize
DataMapper::auto_upgrade!

get'/hello' do
  "Hello World"
end

get '/' do
  haml :home
end

post '/' do
  @instructors = find_instructors(Integer(params[:range]), params[:search])
  @formatted_address = @geo['results'][0]['formatted_address']
  haml :home
end

get '/instructors' do
  @instructors = Instructor.all
  haml :instructors
end

get '/instructor/new' do
  @instructor = Instructor.new
  haml :instructor_new
end

post '/instructor' do
  @geo = geocode(params[:location])

  @instructor = Instructor.new(
    :name => params[:name],
    :location => @geo['results'][0]['formatted_address'],
    :lat => @geo['results'][0]['geometry']['location']['lat'],
    :lng => @geo['results'][0]['geometry']['location']['lng']
  )

  if @instructor.save
    status 201
    redirect '/instructors'
  else
    status 400
    haml :instructor_new
  end
end

get '/instructor/:username' do
  @instructor = Instructor.first(:username => params[:username])
  haml :instructor_details
end

get '/instructor/:username/edit' do
  @instructor = Instructor.first(:username => params[:username])
  haml :instructor_edit
end

put '/instructor/:id' do
  @instructor = Instructor.get(params[:id])
  updates = {
    :name => params[:name],
    :username => params[:username],
    :location => params[:location],
    :image => params[:image],
    :bio => params[:bio],
    :rate => params[:rate],
    :rating => params[:rating]
  }

  if @instructor.update(updates)
    status 201
    redirect '/instructor/' + @instructor.username
  else
    status 400
    haml :instructor_edit
  end


end
