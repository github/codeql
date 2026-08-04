def a ; "x" end
1.times do | x |
   puts a # not a local variable
   a = 3
   puts a # local variable
end
a = 6
puts a
1.times do | x |
   puts a # local variable from top-level
   a += 3
   puts a # local variable from top-level
   a, b, (c, d) = [4, 5, [6, 7]]
   puts a # local variable from top-level
   puts b # new local variable
   puts c # new local variable
   puts d # new local variable
end

# new global variable
$global = 42

# use of a pre-defined global variable
script = $0

class A; end
x = A
module x::B
  x = 1
end
class << x
  x = 2
end
class x::C < x
  x = 3
end
def x.foo
  x = 4
end

module M
 var =  1
 foo = <<-EOF
  #{var}
  #{fun}
  #{var2 = 10}
  #{var2}
 EOF
end

module ExceptionVariable
  class MyException < Exception
  end

  x = 1
  puts x

  begin
    raise MyException
  rescue MyException => x # reuses `x` from above
    puts x
  end
  puts x # prints `MyException`, not `1`
end

module ParameterShadowing
  x = 1
  xs = [1, 2, 3]
  xs.each do |x|
    puts x
  end
  puts x # prints `1`, not `3`
end

class RescueSetter
  def name
    @name
  end

  def name=(value)
    @name = value
  end

  def foo(msg)
    raise msg
  rescue => self.name # calls `name=`
    :caught
  end
end
