class AppointmentSlot
  include DataMapper::Resource

  property :id,       Serial
  property :sTime,    DateTime
  property :eTime,    DateTime
  property :booked,   Boolean, :default => false

  belongs_to :instructor
  belongs_to :court

end
