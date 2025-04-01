def m
  puts "m"
end

def foo
  m # calls m above
  if false
      m = 0
      m # reads local variable m
  else
  end
  m # reads uninitialized local variable m, `nil`
  m2 # undefined local variable or method 'm2' for main (NameError)
end