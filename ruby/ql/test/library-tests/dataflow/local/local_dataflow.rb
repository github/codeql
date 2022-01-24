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
    in 5 => b then sink(b) # $ hasTaintFlow=1
    in a if a > 0 then sink(a) # $ hasTaintFlow=1
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

