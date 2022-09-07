def m1
  x = source "a"
  y = ActionView::SafeBuffer.new(x)
  sink y # $hasTaintFlow=a
end

def m2
  x = ActionView::SafeBuffer.new("a")
  b = source "b"
  y = x.safe_concat(b)
  sink y # $hasTaintFlow=b
end

def m3
  x = ActionView::SafeBuffer.new("a")
  b = source "b"
  x.safe_concat(b)
  sink x # $hasTaintFlow=b
end

def m4
  a = source "a"
  b = source "b"
  x = ActionView::SafeBuffer.new(a)
  y = x.concat(b)
  sink y # $hasTaintFlow=a
end

def m5
  a = source "a"
  b = source "b"
  x = ActionView::SafeBuffer.new(a)
  y = x.insert(i, b)
  sink y # $hasTaintFlow=a
end

def m6
  a = source "a"
  b = source "b"
  x = ActionView::SafeBuffer.new(a)
  y = x.prepend(b)
  sink y # $hasTaintFlow=a
end

def m7
  a = source "a"
  b = source "b"
  x = ActionView::SafeBuffer.new(a)
  y = x.prepend(b)
  sink y # $hasTaintFlow=a
end

def m7
  a = source "a"
  x = ActionView::SafeBuffer.new(a)
  y = x.to_s
  sink y # $hasTaintFlow=a
end

def m8
  a = source "a"
  x = ActionView::SafeBuffer.new(a)
  y = x.to_param
  sink y # $hasTaintFlow=a
end
