class Tennis

	# List all Schedules
	get '/schedules' do
		@schedules = Schedule.all
		@instructors_with_schedules = Instructor.all(:schedules.not => nil)
		haml :'schedules/index'
	end

	# Show Schedule
	get '/schedule/:username/:court_id' do
		@instructor = Instructor.first(:username => params[:username])
		@court = Court.get(params[:court_id])
		@schedule = Schedule.first(
			:instructor_id => @instructor.id,
			:court_id => @court.id
		)
		haml :'schedules/show'
	end


end