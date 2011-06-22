class Tennis

  get '/instructors' do
    @instructors = Instructor.all
    haml :'instructors/index'
  end

  get '/instructor/new' do
    @instructor = Instructor.new
    haml :'instructors/new'
  end

  post '/instructor' do
    @geo = geocode(params[:location])

    @instructor = Instructor.new(
      :name => params[:name],
      :location => @geo['results'][0]['formatted_address'],
      :lat => @geo['results'][0]['geometry']['location']['lat'],
      :lng => @geo['results'][0]['geometry']['location']['lng']
    )

    if @instructor.save
      status 201
      redirect '/instructors'
    else
      status 400
      haml :'instructors/new'
    end
  end

  get '/instructor/:username' do
    @instructor = Instructor.first(:username => params[:username])
    haml :'instructors/profile'
  end

  get '/instructor/:username/edit' do
    @instructor = Instructor.first(:username => params[:username])
    haml :'instructors/edit'
  end

  put '/instructor/:id' do
    @instructor = Instructor.get(params[:id])
    updates = {
      :name => params[:name],
      :username => params[:username],
      :location => params[:location],
      :image => params[:image],
      :bio => params[:bio],
      :rate => params[:rate],
      :rating => params[:rating]
    }

    if @instructor.update(updates)
      status 201
      redirect '/instructor/' + @instructor.username
    else
      status 400
      haml :'instructors/edit'
    end
  end

end