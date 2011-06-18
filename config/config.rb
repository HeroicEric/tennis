set :root, File.join(File.dirname(__FILE__), "..")
set :haml, { :format => :html5 } # default for Haml format is :xhtml

# Set DM logger location and level
DataMapper::Logger.new("log/dm.log", :debug)

configure :development do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/tennis.db")
end

configure :test do
  DataMapper.setup(:default,"sqlite::memory:")
end

# Finalize initialize DB
DataMapper.finalize
DataMapper::auto_upgrade!
