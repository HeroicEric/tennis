class Court
  include DataMapper::Resource

  property :id,             Serial
  property :name,           String, :required => true, :unique => true
  property :rating,         Integer
  property :description,    Text
  property :num_of_courts,  Integer
  property :lights,         Boolean
  property :indoor,         Boolean
  property :wall,           Boolean
  property :clay,           Boolean
  property :grass,          Boolean
  property :proshop,        Boolean
  property :stringing,      Boolean

  # Location properties
  property :geoLat,         Float
  property :geoLng,         Float
  property :street_address, String
  property :city,           String
  property :state,          String
  property :zip,            String

  has n, :schedules
end
