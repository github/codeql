class FooController < ActionController::Base
  # BAD
  def route0
    path = params[:path] # $ Alert
    @content = File.read path # $ Alert
  end

  # BAD - File.absolute_path preserves taint
  def route1
    path = File.absolute_path params[:path] # $ Alert
    @content = File.read path # $ Alert
  end

  # BAD - File.dirname preserves taint
  def route2
    path = "#{File.dirname(params[:path])}/foo" # $ Alert
    @content = File.read path # $ Alert
  end

  # BAD - File.expand_path preserves taint
  def route3
    path = File.expand_path params[:path] # $ Alert
    @content = File.read path # $ Alert
  end

  # BAD - File.path preserves taint
  def route4
    path = File.path params[:path] # $ Alert
    @content = File.read path # $ Alert
  end

  # BAD - File.realdirpath preserves taint
  def route5
    path = File.realdirpath params[:path] # $ Alert
    @content = File.read path # $ Alert
  end

  # BAD - File.realpath preserves taint
  def route6
    path = File.realpath params[:path] # $ Alert
    @content = File.read path # $ Alert
  end

  # BAD - tainted arguments in any position propagate to the return value of
  # File.join
  def route7
    path = File.join("foo", "bar", "baz", params[:path], "qux") # $ Alert
    @content = File.read path # $ Alert
  end

  # GOOD - File.basename does not preserve taint
  def route8
    path = File.basename params[:path] # $ Alert
    @content = File.read path # Sanitized
  end

  # BAD
  def route9
    path = ActiveStorage::Filename.new(params[:path]) # $ Alert
    @content = File.read path # $ Alert
  end

  # GOOD - explicitly sanitized
  def route10
    path = ActiveStorage::Filename.new(params[:path]).sanitized # $ Alert
    @content = File.read path # $ SPURIOUS: Alert (should have been sanitized)
  end

  # BAD
  def route11
    path = ActiveStorage::Filename.new(params[:path]) # $ Alert
    send_file path # $ Alert
  end

  # BAD
  def route12
    path = ActiveStorage::Filename.new(params[:path]) # $ Alert
    bla (Dir.glob path) # $ Alert
    bla (Dir[path]) # $ Alert
  end

  # BAD
  def route13
    path = ActiveStorage::Filename.new(params[:path]) # $ Alert
    load(path) # $ Alert
    autoload(:MyModule, path) # $ Alert
  end

  def require_relative()
    path = ActiveStorage::Filename.new(params[:path]) # $ Alert
    puts "Debug: require_relative(#{path})" # $ Alert
    super(path) # $ Alert
  end
end
