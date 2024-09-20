class A
  def m1(&block)
    r = block.call()
    sink r # $ MISSING: hasValueFlow=1
  end

  def m2
    sink yield # $ hasValueFlow=2
  end
end

A.new.m1 { source(1) }

A.new.m2 { source(2) }

class B
  def [](x)
    yield x
  end
end

b = B.new

b[source(3)] do |x|
  sink x # $ hasValueFlow=3
end
