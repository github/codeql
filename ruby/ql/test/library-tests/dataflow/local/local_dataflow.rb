def foo(a)
  b = a
  c = (p a; b)
  d = c = a
  d = (c = a)
  e = (a += b)
end

array = [1,2,3]
y = for x in array
do
  p x
end

for x in array do
  break 10
end

for x in array do
  if x > 1 then break end
end

while true
 break 5
end

# string flows to x
x = module M; "module" end
# string flows to x
x = class C; "class" end
# string does not flow to x because "def" evaluates to a method symbol
x = def bar; "method" end

def m x 
  if x == 4
     return 7
  end
  "reachable"
end

def m x 
  if x == 4
     return 7
  end
  return 6
  "unreachable"
end

m do
  next "next" if x < 4 
  break "break" if x < 9
  "normal"
end

foo([1, 2, 3])

def foo x
end

def test_case x
  y = case x
  when 1 then 3
  when 2 then x
  when 3
     x
  else
    x
  end
  z = case x
  in 1 then 4
  in 2 then x
  in 3
      x
  else
     x
  end

  z = case source(1)
    in 5 => b then sink(b) # $ hasValueFlow=1
    in a if a > 0 then sink(a) # $ hasValueFlow=1
    in [c, *d, e ] then [
      sink(c), # $ hasTaintFlow=1
      sink(d), # $ hasTaintFlow=1
      sink(e)] # $ hasTaintFlow=1
    in { a: f } then sink(f) # $ hasTaintFlow=1
    in { foo: 1, g: } then sink(g) # $ hasTaintFlow=1
    in { x: } then sink(x); x # $ hasTaintFlow=1
  end
  sink(z) # $ hasTaintFlow=1
end

def and_or
  a = source(1) || source(2)
  sink(a) # $ hasValueFlow=1 hasValueFlow=2
  b = (source(1) or source(2))
  sink(b) # $ hasValueFlow=1 hasValueFlow=2
  
  a = source(1) && source(2)
  sink(a) # $ hasValueFlow=2
  b = (source(1) and source(2))
  sink(b) # $ hasValueFlow=2

  a = source(5)
  a ||= source(6)
  sink(a) # $ hasValueFlow=5 hasValueFlow=6
  b = source(7)
  b &&= source(8)
  sink(b) # $ hasValueFlow=8
end

def object_dup
  sink(source(1).dup) # $ hasValueFlow=1
  sink(source(1).dup.dup) # $ hasValueFlow=1
end

def kernel_tap
  sink(source(1).tap {}) # $ hasValueFlow=1
  source(1).tap { |x| sink(x) } # $ hasValueFlow=1
  sink(source(1).tap {}.tap {}) # $ hasValueFlow=1
end

def dup_tap
  sink(source(1).dup.tap { |x| puts "hello" }.dup)  # $ hasValueFlow=1
end

def use x
  rand()
end

def use_use_madness
  x = ""
  if use(x)
    if use(x) || use(x)
      use(x)
    else
      use(x)
      if use(x) && !use(x)
      end
    end

    if !use(x) || (use(x) && !use(x))
      nil
    elsif use(x) || use(x)
          use(x)
    end

    use(x)
    use(x)
  end
end