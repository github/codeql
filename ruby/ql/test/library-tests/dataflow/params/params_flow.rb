def taint x
    x
end

def sink x
    puts x
end

def positional(p1, p2)
    sink p1 # $ hasValueFlow=1 $ hasValueFlow=16 $ hasValueFlow=18 $ hasValueFlow=61
    sink p2 # $ hasValueFlow=2 $ hasValueFlow=19 $ hasValueFlow=61 $ hasValueFlow=17
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
    sink p1 # $ hasValueFlow=20 $ hasValueFlow=23 $ hasValueFlow=24
    sink (posargs[0]) # $ hasValueFlow=22 $ hasValueFlow=21 $ hasValueFlow=25
    sink (posargs[1])
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

def splatmid(x, y, *z, w, r)
    sink x # $ hasValueFlow=27 $ hasValueFlow=32 $ hasValueFlow=45
    sink y # $ hasValueFlow=28 $ hasValueFlow=46 $ hasValueFlow=33
    sink z[0] # $ MISSING: hasValueFlow=47 $ hasValueFlow=29 $ hasValueFlow=34
    sink z[1] # $ MISSING: hasValueFlow=48 $ hasValueFlow=35
    sink w # $ MISSING: hasValueFlow=30 $ hasValueFlow=50 $ hasValueFlow=36
    sink r # $ MISSING: hasValueFlow=31 $ hasValueFlow=51 $ hasValueFlow=37
end

splatmid(taint(27), taint(28), taint(29), taint(30), taint(31))

args = [taint(33), taint(34), taint(35), taint(36)]
splatmid(taint(32), *args, taint(37))

def pos_many(t, u, v, w, x, y, z)
    sink t # $ hasValueFlow=38 $ hasValueFlow=66
    sink u # $ hasValueFlow=39 $ hasValueFlow=67
    sink v # $ hasValueFlow=40
    sink w # $ hasValueFlow=41
    sink x # $ hasValueFlow=42
    sink y # $ hasValueFlow=43
    sink z # $ MISSING: hasValueFlow=44
end

args = [taint(40), taint(41), taint(42), taint(43)]
pos_many(taint(38), taint(39), *args, taint(44))

splatmid(taint(45), taint(46), *[taint(47), taint(48), taint(49)], taint(50), taint(51))

def splatmidsmall(a, *splats, b)
    sink a # $ hasValueFlow=52 $ hasValueFlow=55
    sink splats[0] # $ MISSING: hasValueFlow=53
    sink splats[1]
    sink b # $ MISSING: hasValueFlow=57 $ hasValueFlow=54
end

splatmidsmall(taint(52), *[taint(53), taint(54)])
splatmidsmall(taint(55), taint(56), taint(57))

def splat_followed_by_keyword_param(a, *b, c:)
    sink a # $ hasValueFlow=58
    sink b[0] # $ hasValueFlow=59
    sink c # $ hasValueFlow=60
end

splat_followed_by_keyword_param(taint(58), taint(59), c: taint(60))

x = []
x[some_index()] = taint(61)
positional(*x)

def destruct((a,b), (c,(d,e)))
    sink a # $ MISSING: hasValueFlow=62
    sink b # $ MISSING: hasValueFlow=63
    sink c # $ MISSING: hasValueFlow=64
    sink d
    sink e # $ MISSING: hasValueFlow=65
end

destruct([taint(62), taint(63)], [taint(64), [0, taint(65)]])

args = [taint(66), taint(67)]
pos_many(*args, taint(68), nil, nil, nil, nil)

def splatall(*args)
    sink args[1] # $ hasValueFlow=70
end

splatall(*[taint(69), taint(70), taint(71)])

def hashSplatSideEffect(**kwargs)
    kwargs[:p1].insert(0, kwargs[:p2])
end

kwargs = { p1: [], p2: taint(72) }
sink(kwargs[:p1][0])
hashSplatSideEffect(**kwargs)
sink(kwargs[:p1][0]) # $ MISSING: hasValueFlow=72

p1 = []
sink(p1[0])
hashSplatSideEffect(p1: p1, p2: taint(73))
sink(p1[0]) # $ MISSING: hasValueFlow=73

def keywordSideEffect(p1:, p2:)
    p1.insert(0, p2)
end

kwargs = { p1: [], p2: taint(74) }
sink(kwargs[:p1][0])
keywordSideEffect(**kwargs)
sink(kwargs[:p1][0]) # $ MISSING: hasValueFlow=74

p1 = []
sink(p1[0])
keywordSideEffect(p1: p1, p2: taint(75))
sink(p1[0]) # $ hasValueFlow=75

def splatSideEffect(*posargs)
    posargs[0].insert(0, posargs[1])
end

posargs = [ [], taint(76) ]
sink(posargs[0][0])
splatSideEffect(*posargs)
sink(posargs[0][0]) # $ MISSING: hasValueFlow=76

p1 = []
sink(p1[0])
splatSideEffect(p1, taint(77))
sink(p1[0]) # $ MISSING: hasValueFlow=77

def positionSideEffect(p1, p2)
    p1.insert(0, p2)
end

args = [ [], taint(78) ]
sink(args[0][0])
positionSideEffect(*args)
sink(args[0][0]) # $ MISSING: hasValueFlow=78

p1 = []
sink(p1[0])
positionSideEffect(p1, taint(79))
sink(p1[0]) # $ hasValueFlow=79

int_hash = {
    0 => taint(80),
    1 => "B"
}

def foo(x, y)
    sink (x[0])
    sink (x[1]) # $ MISSING: hasValueFlow=80
    sink (y[0])
    sink (y[1])
end

foo(*int_hash)
