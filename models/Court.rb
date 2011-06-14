class Court
  include DataMapper::Resource

  property :id,            Serial
  property :name,          String

  has n, :timeslots
end
