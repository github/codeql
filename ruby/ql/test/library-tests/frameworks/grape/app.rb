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
end

class AdminAPI < Grape::API
  get '/admin' do
    params[:token]
  end
end