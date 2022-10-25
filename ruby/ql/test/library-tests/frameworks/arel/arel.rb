def m1
  x = source 1
  sink(Arel.sql(x)) # $hasTaintFlow=1
end

def m2
  x = 1
  sink(Arel.sql(x))
end

def m3
  x = source 1
  sink(Unrelated.method(x))
end
