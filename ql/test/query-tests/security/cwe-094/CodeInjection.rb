class UsersController < ActionController::Base
  def create
    code = params[:code]

    # BAD
    eval(code)

    # BAD
    eval(params)

    # GOOD
    Foo.new.bar(code)

    # BAD
    Foo.class_eval(code)

    # BAD
    Foo.module_eval(code)

    # GOOD
    Bar.class_eval(code)
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

class Bar
  def self.class_eval(x)
    true
  end
end