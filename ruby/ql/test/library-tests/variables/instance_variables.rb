@top = 1

def foo
  @foo = 10
end

def print_foo
  puts @foo
end

puts @top

class X
  @x = 10
  def m()
    @y = 7
  end
end

module M
 @m = 10
 def n()
   @n = 7
 end
end

puts { 
  @x = 100
}

def bar
 1.times { @x = 200 }
end

class C
  @x = 42
  def x 
   def y
     @x = 10
   end
   y
   p @x
  end
 end