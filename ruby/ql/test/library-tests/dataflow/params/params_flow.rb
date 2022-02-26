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
    sink p1 # $ hasValueFlow=3 $ hasValueFlow=6
    sink p2 # $ hasValueFlow=4 $ hasValueFlow=5
end

keyword(p1: taint(3), p2: taint(4))
keyword(p2: taint(5), p1: taint(6))
