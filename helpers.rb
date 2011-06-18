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
