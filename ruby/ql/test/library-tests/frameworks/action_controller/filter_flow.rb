Rails.application.routes.draw do
  get 'one/b', to: "one#b"
  get 'two/b', to: "two#b"
  get 'three/b', to: "three#b"
  get 'four/b', to: "four#b"
  get 'five/b', to: "five#b"
end

class OneController < ActionController::Base
  before_action :a
  after_action :c
  
  def a
    @foo = params[:foo]
  end

  def b
  end

  def c
    sink @foo
  end
end

class TwoController < ActionController::Base
  before_action :a
  after_action :c
  
  def a
    @foo = params[:foo]
  end

  def b
    @foo = "safe"
  end

  def c
    sink @foo
  end
end

class ThreeController < ActionController::Base
  before_action :a
  after_action :c
  
  def a
    @foo = params[:foo]
    @foo = "safe"
  end

  def b
  end

  def c
    sink @foo
  end
end

class FourController < ActionController::Base
  before_action :a
  after_action :c
  
  def a
    @foo.bar = params[:foo]
  end

  def b
  end

  def c
    sink(@foo.bar)
  end
end

class FiveController < ActionController::Base
  before_action :a
  after_action :c
  
  def a
    self.taint_foo
  end

  def b
  end

  def c
    sink  @foo
  end
  
  def taint_foo
    @foo = params[:foo]
  end
end