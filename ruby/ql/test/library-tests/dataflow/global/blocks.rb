class A
  def m1(&block)
    r = block.call() # $ MISSING: hasValueFlow=1
    sink r
  end

  def m2
    sink yield # $ hasValueFlow=2
  end
end

A.new.m1 { source(1) }

A.new.m2 { source(2) }
