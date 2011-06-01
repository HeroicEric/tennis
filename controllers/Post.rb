# Add a new Post
get '/post/new' do
  @post = Post.new
  
  haml :post_new
end

# Create a new Post
post '/post' do
  @post = Post.create(
    :title => params[:title],
    :slug => Post.make_slug(params[:title]),
    :body => params[:body]
  )

  if @post.save
    status 201 # Created successfully
    redirect '/blog'
  else
    status 400 # Bad Request(
    haml :post_new
  end
  
end

# View a Post
get '/post/:slug' do
  @shows = Show.all
  @post = Post.first(:slug => params[:slug])
  @posts = Post.all
  @disqus_identifier = @post.id
  haml :post
end

# Edit Post
get '/post/:slug/edit' do
  @post = Post.first(:slug => params[:slug])
  
  haml :post_edit
end

# Update Post
put '/post/:slug' do
  @post = Post.first(:slug => params[:slug])

  if @post.update(
      :title => params[:title],
      :slug => params[:slug],
      :body => params[:body]
    )
    status 201
    redirect '/post/' + @post.slug
  else
    status 400
    haml :post_edit
  end
end

delete '/post/:slug' do
  @post = Post.first(:slug => params[:slug])
  @post.comments.destroy
  @post.destroy

  if @post.destroy
    status 201
    redirect "/blog"
  else
    status 400
    redirect '/post/' + @post.slug + '/edit'
  end
end
