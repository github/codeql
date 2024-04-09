class FooController < ActionController::Base
  # BAD
  def route0
    path = params[:path]
    @content = File.read path
  end

  # BAD - File.absolute_path preserves taint
  def route1
    path = File.absolute_path params[:path]
    @content = File.read path
  end

  # BAD - File.dirname preserves taint
  def route2
    path = "#{File.dirname(params[:path])}/foo"
    @content = File.read path
  end

  # BAD - File.expand_path preserves taint
  def route3
    path = File.expand_path params[:path]
    @content = File.read path
  end

  # BAD - File.path preserves taint
  def route4
    path = File.path params[:path]
    @content = File.read path
  end

  # BAD - File.realdirpath preserves taint
  def route5
    path = File.realdirpath params[:path]
    @content = File.read path
  end

  # BAD - File.realpath preserves taint
  def route6
    path = File.realpath params[:path]
    @content = File.read path
  end

  # BAD - tainted arguments in any position propagate to the return value of
  # File.join
  def route7
    path = File.join("foo", "bar", "baz", params[:path], "qux")
    @content = File.read path
  end

  # GOOD - File.basename does not preserve taint
  def route8
    path = File.basename params[:path]
    @content = File.read path
  end

  # BAD
  def route9
    path = ActiveStorage::Filename.new(params[:path])
    @content = File.read path
  end

  # GOOD - explicitly sanitized
  def route10
    path = ActiveStorage::Filename.new(params[:path]).sanitized
    @content = File.read path
  end

  # BAD
  def route11
    path = ActiveStorage::Filename.new(params[:path])
    send_file path
  end

  # BAD
  def route12
    path = ActiveStorage::Filename.new(params[:path])
    bla (Dir.glob path)
    bla (Dir[path])
  end

  # BAD
  def route13
    path = ActiveStorage::Filename.new(params[:path])
    load(path)
    autoload(:MyModule, path)
  end

  def require_relative()
    path = ActiveStorage::Filename.new(params[:path])
    puts "Debug: require_relative(#{path})"
    super(path)
  end

  require 'pathname'

  def safe_example_folder()
    filename = params[:path]
    user_directory = "/home/#{current_user}/public" # Assuming `current_user` method returns the user's name

    public_folder = Pathname.new(user_directory).cleanpath.to_s
    file_path = Pathname.new(File.join(user_directory, filename)).cleanpath.to_s

    # GOOD: Ensure that the path stays within the public folder
    if !file_path.start_with?(public_folder + File::SEPARATOR)
      raise ArgumentError, "Invalid filename"
    else
      @content = File.read(file_path) # GOOD, but we falsely report a vulnerability
    end
  end

  def safe_example_normalize()
    filename = params[:path]
    # GOOD: Ensure that the filename has no path separators or parent directory references
    if filename.include?("..") || filename.include?("/") || filename.include?("\\")
      raise ArgumentError, "Invalid filename"
    else
      # Assuming files are stored in a specific directory, e.g., /home/user/files/
      @content = File.read("/home/user/files/#{filename}") # GOOD, but we falsely report a vulnerability
    end
  end
end
