def taint x
    x
end

def sink x
    puts x
end

def positional(p1, p2)
    sink p1 # $ hasValueFlow=1
    sink p2 # $ hasValueFlow=2
end

positional(taint(1), taint(2))

def keyword(p1:, p2:)
    sink p1 # $ hasValueFlow=3 $ hasValueFlow=6 $ hasValueFlow=8
    sink p2 # $ hasValueFlow=4 $ hasValueFlow=5 $ hasValueFlow=7
end

keyword(p1: taint(3), p2: taint(4))
keyword(p2: taint(5), p1: taint(6))
keyword(:p2 => taint(7), :p1 => taint(8))

def kwargs(p1:, **kwargs)
    sink p1 # $ hasValueFlow=9 $ hasValueFlow=13
    sink (kwargs[:p1])
    sink (kwargs[:p2]) # $ hasValueFlow=10
    sink (kwargs[:p3]) # $ hasValueFlow=11 $ hasValueFlow=12
    sink (kwargs[:p4])
end

kwargs(p1: taint(9), p2: taint(10), p3: taint(11), p4: "")
args = { p3: taint(12), p4: "" }
kwargs(p1: taint(13), **args)
