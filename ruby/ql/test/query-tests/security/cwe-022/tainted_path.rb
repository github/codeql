class FooController < ActionController::Base
  # BAD
  def route0
    path = params[:path] # $ Source=path1
    @content = File.read path # $ Alert=path1
  end

  # BAD - File.absolute_path preserves taint
  def route1
    path = File.absolute_path params[:path] # $ Source=path2
    @content = File.read path # $ Alert=path2
  end

  # BAD - File.dirname preserves taint
  def route2
    path = "#{File.dirname(params[:path])}/foo" # $ Source=path3
    @content = File.read path # $ Alert=path3
  end

  # BAD - File.expand_path preserves taint
  def route3
    path = File.expand_path params[:path] # $ Source=path4
    @content = File.read path # $ Alert=path4
  end

  # BAD - File.path preserves taint
  def route4
    path = File.path params[:path] # $ Source=path5
    @content = File.read path # $ Alert=path5
  end

  # BAD - File.realdirpath preserves taint
  def route5
    path = File.realdirpath params[:path] # $ Source=path6
    @content = File.read path # $ Alert=path6
  end

  # BAD - File.realpath preserves taint
  def route6
    path = File.realpath params[:path] # $ Source=path7
    @content = File.read path # $ Alert=path7
  end

  # BAD - tainted arguments in any position propagate to the return value of
  # File.join
  def route7
    path = File.join("foo", "bar", "baz", params[:path], "qux") # $ Source=path8
    @content = File.read path # $ Alert=path8
  end

  # GOOD - File.basename does not preserve taint
  def route8
    path = File.basename params[:path]
    @content = File.read path
  end

  # BAD
  def route9
    path = ActiveStorage::Filename.new(params[:path]) # $ Source=path9
    @content = File.read path # $ Alert=path9
  end

  # GOOD - explicitly sanitized
  def route10
    path = ActiveStorage::Filename.new(params[:path]).sanitized
    @content = File.read path
  end

  # BAD
  def route11
    path = ActiveStorage::Filename.new(params[:path]) # $ Source=path10
    send_file path # $ Alert=path10
  end

  # BAD
  def route12
    path = ActiveStorage::Filename.new(params[:path]) # $ Source=path11
    bla (Dir.glob path) # $ Alert=path11
    bla (Dir[path]) # $ Alert=path11
  end

  # BAD
  def route13
    path = ActiveStorage::Filename.new(params[:path]) # $ Source=path12
    load(path) # $ Alert=path12
    autoload(:MyModule, path) # $ Alert=path12
  end

  def require_relative()
    path = ActiveStorage::Filename.new(params[:path]) # $ Source=path13
    puts "Debug: require_relative(#{path})"
    super(path) # $ Alert=path13
  end
end
