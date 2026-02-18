require 'active_job'

class UsersController < ActionController::Base
  def create
    code = params[:code] # $ Source

    # BAD
    eval(code) # $ Alert

    # BAD
    eval(params) # $ Alert

    # GOOD - user input is in second argument, which is not evaluated as Ruby code
    send(:sanitize, params[:code])

    # GOOD
    Foo.new.bar(code)

    # BAD
    Foo.class_eval(code) # $ Alert

    # BAD
    Foo.module_eval(code) # $ Alert

    # GOOD
    Bar.class_eval(code)

    # BAD
    const_get(code) # $ Alert

    # BAD
    Foo.const_get(code) # $ Alert

    # GOOD
    Bar.const_get(code)

    # BAD
    eval(Regexp.escape(code)) # $ Alert

    # BAD
    ActiveJob::Serializers.deserialize(code) # $ Alert
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

class UsersController < ActionController::Base
  def create
    code = params[:code] # $ Source

    # BAD
    obj().send(code, "foo"); # $ Alert

    # GOOD
    obj().send("prefix_" + code + "_suffix", "foo");

    # GOOD
    obj().send("prefix_#{code}_suffix", "foo");

    # BAD
    eval("prefix_" + code + "_suffix"); # $ Alert

    # BAD
    eval("prefix_#{code}_suffix"); # $ Alert

    # BAD
    eval(code); # $ Alert
  end
end

Rails.application.routes.draw { resources :posts }

class PostsController < ActionController::Base
  before_action :foo
  before_action :bar
  after_action :baz

  def index
  end

  def foo
    @foo = params[:foo] # $ Source
  end

  def bar
  end

  def baz
    eval(@foo) # $ Alert
  end
end
