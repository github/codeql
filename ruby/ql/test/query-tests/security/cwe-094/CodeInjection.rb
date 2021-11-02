class UsersController < ActionController::Base
  def create
    code = params[:code]

    # BAD
    eval(code)

    # BAD
    eval(params)

    # GOOD
    Foo.new.bar(code)
  end

  def update
    # GOOD
    eval("foo")
  end
end

class Foo
  def eval(x)
    true
  end

  def bar(x)
    eval(x)
  end
end
