require_relative "./module"

class B
  include M1

  def foo(x, y)
  end
end

class C
  extend M1
end
