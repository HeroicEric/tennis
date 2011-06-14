class Timeslot
  include DataMapper::Resource

  property :id,       Serial
  property :tStart,   DateTime
  property :tEnd,     DateTime
  property :booked,   Boolean, :default => false

  belongs_to :instructor
  belongs_to :court
end
