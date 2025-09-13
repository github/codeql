class MyAPI < Grape::API
  version 'v1', using: :header, vendor: 'myapi'
  format :json
  prefix :api

  desc 'Simple get endpoint'
  get '/hello/:name' do
    name = params[:name]
    user_agent = headers['User-Agent']
    "Hello #{name}!"
  end

  desc 'Post endpoint with params'
  params do
    requires :message, type: String
  end
  post '/messages' do
    msg = params[:message]
    { status: 'received', message: msg }
  end

  desc 'Put endpoint accessing request'
  put '/update/:id' do
    id = params[:id]
    body = request.body.read
    { id: id, body: body }
  end

  desc 'Delete endpoint'
  delete '/items/:id' do
    params[:id]
  end

  desc 'Patch endpoint'
  patch '/items/:id' do
    params[:id]
  end

  desc 'Head endpoint'
  head '/status' do
    # Just return status
  end

  desc 'Options endpoint'
  options '/info' do
    headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
  end

  desc 'Route param endpoint'
  get '/users/:user_id/posts/:post_id' do
    user_id = route_param(:user_id)
    post_id = route_param('post_id')
    { user_id: user_id, post_id: post_id }
  end

  desc 'Route param block pattern'
  route_param :id do
    get do
      # params[:id] is user input from the path parameter
      id = params[:id]
      { id: id }
    end
  end

  # Headers block for defining expected headers
  headers do
    requires :Authorization, type: String
    optional 'X-Custom-Header', type: String
  end

  # Cookies block for defining expected cookies
  cookies do
    requires :session_id, type: String
    optional :tracking_id, type: String
  end

  desc 'Endpoint that uses cookies method'
  get '/cookie_test' do
    session = cookies[:session_id]
    tracking = cookies['tracking_id']
    { session: session, tracking: tracking }
  end

  desc 'Endpoint that uses headers method'
  get '/header_test' do
    auth = headers[:Authorization]
    custom = headers['X-Custom-Header']
    { auth: auth, custom: custom }
  end
end

class AdminAPI < Grape::API
  get '/admin' do
    params[:token]
  end
end