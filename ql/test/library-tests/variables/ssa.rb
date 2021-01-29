def m b        # defines b_0
  i = 0        # defines i_0
  puts i       # reads i_0 (first read)
  puts i + 1   # reads i_0 (last read)
  if b         # reads b_0
    i = 1      # defines i_1 
    puts i     # reads i_1 (first read)
    puts i + 1 # reads i_1 (last read)
  else
    i = 2      # defines i_2
    puts i     # reads i_2 (first read)
    puts i + 1 # reads i_2 (last read)
  end
               # defines i_3 = phi(i_1, i_2)
  puts i       # reads i3 (first read and last read)
end

def m1 x
  while x >= 0
    puts x
    x -= 1
  end
end
  
def m2 elements
  for elem in elements do
    puts elem
  end
  puts elem
end

def m3
  [1,2,3].each do |x|
    puts x
  end
end

def m4
  puts m3
  m3 = 10
  puts m3 + 1
end

def m5 b
  x = 0 if b
  puts x
end

def m6 (x = (y = 10))
  puts y
end

def m7 foo
  x = foo.x
  puts x
end

def m8
  x = 10
  x += 10
  puts x
end

def m9 a
  captured = 10
  a.times do |a|
    puts a
    puts captured
    captured += 1
  end
  puts captured
end

def m10
  captured = 0
  foo do
     bar(baz: captured)
  end
end

def m11
  captured = 0
  foo do
     bar do
         puts captured
     end
  end
end