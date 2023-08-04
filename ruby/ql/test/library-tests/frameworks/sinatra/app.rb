class MyApp < Sinatra::Base
  get '/hello/:name' do
    "Hello #{params['name']}!"
  end
  
  get '/goodbye/:name' do |n|
    "Goodbyte #{n}!"
  end
  
  get '/say/*/to/*' do
    # matches /say/hello/to/world
    params['splat'] # => ["hello", "world"]
  end
  
  get '/download/*.*' do
    # matches /download/path/to/file.xml
    params['splat'] # => ["path/to/file", "xml"]
  end
  
  get '/download/*.*' do |path, ext|
    [path, ext] # => ["path/to/file", "xml"]
  end
  
  get /\/hello\/([\w]+)/ do
    "Hello, #{params['captures'].first}!"
  end
  
  get %r{/hello/([\w]+)} do |c|
    # Matches "GET /meta/hello/world", "GET /hello/world/1234" etc.
    "Hello, #{c}!"
  end
  
  get '/posts/:format?' do
    # matches "GET /posts/" and any extension "GET /posts/json", "GET /posts/xml" etc
  end
  
  get '/posts' do
    # matches "GET /posts?title=foo&author=bar"
    title = params['title']
    author = params['author']
    # uses title and author variables; query is optional to the /posts route
  end
  
  get '/foo', :agent => /Songbird (\d\.\d)[\d\/]*?/ do
    "You're using Songbird version #{params['agent'][0]}"
  end
  
  get '/foo' do
    # Matches non-songbird browsers
  end
  
  get '/', :host_name => /^admin\./ do
    "Admin Area, Access denied!"
  end
  
  get '/', :provides => 'html' do
    haml :index
  end
  
  get '/', :provides => ['rss', 'atom', 'xml'] do
    builder :feed
  end
  
  set(:probability) { |value| condition { rand <= value } }

  get '/win_a_car', :probability => 0.1 do
    "You won!"
  end

  get '/win_a_car' do
    "Sorry, you lost."
  end
  
  get '/' do
    @foo = params["foo"]
    erb :index, locals: {foo:  @foo}
  end
  
  get '/' do
    code = "<%= Time.now %>"
    erb code
  end
  
  before do
    @note = 'Hi!'
    request.path_info = '/foo/bar/baz'
  end
  
  get '/foo/*' do
    @note #=> 'Hi!'
    params['splat'] #=> 'bar/baz'
  end
  
  get "/home" do
    sink @user # $ hasValueFlow=a
  end
  
  after do
    puts response.status
  end
  
  before do
    @user = source "a"
  end
  
  before '/protected/*' do
    authenticate!
  end
  
  
  after '/create/:slug' do |slug|
    session[:last_slug] = slug
  end
end

