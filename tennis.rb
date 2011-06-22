require 'rubygems'
require 'bundler'
Bundler.require

require 'net/http'
require 'uri'

# Finalize initialize DB
DataMapper.finalize
DataMapper::auto_upgrade!

#require helpers
require_relative "helpers"

# Make Tennis a subclas of Sinatra::Base
class Tennis < Sinatra::Base; end;

# Set DM logger location and level
DataMapper::Logger.new("log/dm.log", :debug)

class Tennis < Sinatra::Base

	# Configure Environments
	configure :development do DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/tennis.db") end
	configure :test do DataMapper.setup(:default,"sqlite::memory:") end
	configure :production do DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/tennis.db") end

	# Require Models & Controllers
	Dir.glob("#{Dir.pwd}/models/*.rb") { |m| require "#{m.chomp}" }
	Dir.glob("#{Dir.pwd}/controllers/*.rb") { |m| require "#{m.chomp}" }

	set :run, true
	set :views, File.dirname(__FILE__) + "/views"
	set :public, File.dirname(__FILE__) + "/public"
	set :root, File.join(File.dirname(__FILE__), "..")
	set :haml, { :format => :html5 } # default for Haml format is :xhtml

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

end