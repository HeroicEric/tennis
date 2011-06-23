class Instructor
  include DataMapper::Resource
  include DataMapper::Validate

  property :id,       Serial
  property :name,     String
  property :username, String
  property :email,    String
  property :location, String
  property :lat,      Float
  property :lng,      Float
  property :image,    String, :default => "http://placesheen.com/100/100"
  property :bio,      Text
  property :rate,     Integer
  property :rating,   Integer

  has n, :schedules

  validates_presence_of      :email, :name
  validates_length_of        :email, :min => 3, :max => 100
  validates_uniqueness_of    :email, :case_sensitive => false
  validates_format_of        :email, :with => :email_address

  def link
    "<a href='/instructor/#{username}'>#{name}</a>"
  end
end
