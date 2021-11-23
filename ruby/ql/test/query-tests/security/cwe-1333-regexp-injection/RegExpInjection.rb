class FooController < ActionController::Base
  # BAD
  def route0
    name = params[:name]
    regex = /#{name}/
  end

  # BAD
  def route1
    name = params[:name]
    regex = /foo#{name}bar/
  end

  # BAD
  def route2
    name = params[:name]
    regex = Regexp.new(name)
  end

  # BAD
  def route3
    name = params[:name]
    regex = Regexp.new("@" + name)
  end

  # GOOD - string is compared against a constant string
  def route4
    name = params[:name]
    regex = Regexp.new("@" + name) if name == "foo"
  end

  # GOOD - string is compared against a constant string array
  def route5
    name = params[:name]
    if ["John", "Paul", "George", "Ringo"].include?(name)
      regex = /@#{name}/
    end
  end

  # GOOD - string is explicitly escaped
  def route6
    name = params[:name]
    regex = Regexp.new(Regexp.escape(name))
  end

  # GOOD - string is explicitly escaped
  def route7
    name = params[:name]
    regex = Regexp.new(Regexp.quote(name))
  end

  # BAD
  def route8
    name = params[:name]
    regex = Regexp.compile("@" + name)
  end
end
