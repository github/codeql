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
  m  #$ Alert
  m2 # undefined local variable or method 'm2' for main (NameError)
end

def test_guards
  if (a = 3 && a)  #$ Alert
      a
  end
  if (a = 3) && a  # OK - a is assigned in the previous conjunct
      a
  end
  if !(a = 3) or a  # OK - a is assigned in the previous conjunct
      a
  end
  if false
      b = 0
  end
  b.nil?
  b || 0  #$ SPURIOUS: Alert
  b&.m  #$ SPURIOUS: Alert
  b if b  #$ SPURIOUS: Alert
  b.close if b && !b.closed #$ SPURIOUS: Alert
  b.blowup if b || !b.blownup #$ Alert
end

def test_loop
  begin
      if false
          a = 0
      else
          set_a
      end   
  end until a  #$ SPURIOUS: Alert
  a  #$ SPURIOUS: Alert
end