def taint x
    x
end

def sink x
    puts x
end

def positional(p1, p2)
    sink p1 # $ hasValueFlow=1 $ hasValueFlow=16 $ MISSING: hasValueFlow=18
    sink p2 # $ hasValueFlow=2 $ MISSING: hasValueFlow=17 $ MISSING: hasValueFlow=19
end

positional(taint(1), taint(2))

def keyword(p1:, p2:)
    sink p1 # $ hasValueFlow=3 $ hasValueFlow=6 $ hasValueFlow=8 $ hasValueFlow=16
    sink p2 # $ hasValueFlow=4 $ hasValueFlow=5 $ hasValueFlow=7 $ hasValueFlow=17
end

keyword(p1: taint(3), p2: taint(4))
keyword(p2: taint(5), p1: taint(6))
keyword(:p2 => taint(7), :p1 => taint(8))

def kwargs(p1:, **kwargs)
    sink p1 # $ hasValueFlow=9 $ hasValueFlow=13 $ hasValueFlow=14
    sink (kwargs[:p1])
    sink (kwargs[:p2]) # $ hasValueFlow=10 $ hasValueFlow=15
    sink (kwargs[:p3]) # $ hasValueFlow=11 $ hasValueFlow=12
    sink (kwargs[:p4])
end

kwargs(p1: taint(9), p2: taint(10), p3: taint(11), p4: "")
args = { p3: taint(12), p4: "" }
kwargs(p1: taint(13), **args)

args = {:p1 => taint(14), :p2 => taint(15) }
kwargs(**args)

args = {:p1 => taint(16) }
keyword(p2: taint(17), **args)

args = [taint(17)]
positional(taint(16), *args)

args = [taint(18), taint(19)]
positional(*args)

def posargs(p1, *posargs)
    sink p1 # $ hasValueFlow=20 $ hasValueFlow=23 $ MISSING: hasValueFlow=24
    sink (posargs[0]) # $ MISSING: hasValueFlow=21 $ MISSING: hasValueFlow=22 $ MISSING: hasValueFlow=25
end

posargs(taint(20), taint(21))

args = [taint(22)]
posargs(taint(23), *args)

args = [taint(24), taint(25)]
posargs(*args)

args = taint(26)
def splatstuff(*x)
    sink x[0] # $ hasValueFlow=26
end
splatstuff(*args)