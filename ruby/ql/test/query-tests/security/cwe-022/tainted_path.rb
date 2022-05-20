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
end
