@@x = 42

p @@x

def print
 p @@x
end

class X
  def b
    p @@x
  end
  def self.s
   p @@x
  end
end 

class Y < BasicObject
  @@x = 10
end 

module M
  @@x = 12
end

module N
  include M
  p @@x
end
