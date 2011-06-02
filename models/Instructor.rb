class Instructor
  include DataMapper::Resource

  property :id,       Serial
  property :name,     String
  property :location, String
  property :lat,      Float
  property :lng,      Float
end
