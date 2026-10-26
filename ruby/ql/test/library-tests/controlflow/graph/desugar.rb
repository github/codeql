def m1 x
  x += 1
end

def m2 x
  x.foo.count = 1
end

def m3 x
  x.foo[0] = 1
end

def m4 x
  x.foo.count += 1
end

def m5 x, y
  x.foo[0, y.bar, x.baz + 3] += 1
end

def m6
  x, *y, z.bar = [1, 2, 3, 4]
end

def m7
  x, (y, z) = [1, [2, 3]]
end

class X
  @x = 1
  @x += 2

  @@y = 3
  @@y /= 4
end

$global_var = 5
$global_var *= 6
