class UsersController < ActionController::Base
  def create
    code = params[:code]

    # BAD
    eval(code)

    # BAD
    eval(params)

    # GOOD - user input is in second argument, which is not evaluated as Ruby code
    send(:sanitize, params[:code])

    # GOOD
    Foo.new.bar(code)

    # BAD
    Foo.class_eval(code)

    # BAD
    Foo.module_eval(code)

    # GOOD
    Bar.class_eval(code)
    
    # BAD
    const_get(code)
    
    # BAD
    Foo.const_get(code)
    
    # GOOD
    Bar.const_get(code)

    # BAD
    eval(Regexp.escape(code))
  end

  def update
    # GOOD
    eval("foo")
  end

  private

  def sanitize(code)
    true
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
  
  def self.const_get(x)
    true
  end
end