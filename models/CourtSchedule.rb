class CourtSchedule
	include DataMapper::Resource
	include DataMapper::Validate

	property :id,        Serial
	property :hours,     Text

	belongs_to :instructor, :key => true
	belongs_to :court, :key => true
end