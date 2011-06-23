class Schedule
	include DataMapper::Resource
	include DataMapper::Validate
	include DataMapper::Serialize

	property :id,        Serial
	property :hours,     Text

	belongs_to :instructor, :key => true
	belongs_to :court, :key => true

	def get_hours
		schedule = IceCube::Schedule.from_yaml(hours)
	end
end