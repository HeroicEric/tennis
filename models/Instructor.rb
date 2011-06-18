class Instructor
  include DataMapper::Resource

  property :id,       Serial
  property :name,     String
  property :username, String
  property :location, String
  property :lat,      Float
  property :lng,      Float
  property :image,    String, :default => "http://placesheen.com/100/100"
  property :bio,      Text
  property :rate,     Integer
  property :rating,   Integer

  has n, :appointmentSlots

  def link
    "<a href='/instructor/#{username}'>#{name}</a>"
  end
end
