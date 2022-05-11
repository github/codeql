def m0(i)
    a = *source(0.1)
    sink(a[0]) # $ hasValueFlow=0.1
    sink(a[1]) # $ hasTaintFlow=0.1 
    sink(a[i]) # $ hasValueFlow=0.1
end

def m1(i)
    a = [0, source(1), 2]
    sink(a[0])
    sink(a[1]) # $ hasValueFlow=1
    sink(a[2])
    sink(a[i]) # $ hasValueFlow=1
end

def m2(i)
    a = Array.new(1, source(2.1))
    sink(a[0]) # $ hasValueFlow=2.1
    sink(a[i]) # $ hasValueFlow=2.1

    b = Array.new(a)
    sink(b[0]) # $ hasValueFlow=2.1
    sink(b[i]) # $ hasValueFlow=2.1

    c = Array.new(1) do |x|
        source(2.2)
    end
    sink(c[0]) # $ hasValueFlow=2.2
    sink(c[i]) # $ hasValueFlow=2.2
end

def m3
    a = [source(3), 1]
    b = Array.try_convert(a)
    sink(b[0]) # $ hasValueFlow=3
    sink(b[1])
end

def m4
    a = [source(4.1), 1]
    b = [2, 3, source(4.2)]
    c = a & b
    sink(c[0]) # $ hasValueFlow=4.1 $ hasValueFlow=4.2
    sink(c[1]) # $ hasValueFlow=4.1 $ hasValueFlow=4.2
end

def m5
    a = [source(5), 1]
    b = a * 3
    sink(b[0]) # $ hasValueFlow=5
    sink(b[1]) # $ hasValueFlow=5
end

def m6
    a = [source(6.1), 1]
    b = [2, source(6.2)]
    c = a + b
    sink(c[0]) # $ hasValueFlow=6.1 $ hasValueFlow=6.2
    sink(c[1]) # $ hasValueFlow=6.2
end

def m7
    a = [source(7.1), 1]
    b = [2, source(7.2)]
    c = a - b
    sink(c[0]) # $ hasValueFlow=7.1
    sink(c[1]) # $ hasValueFlow=7.1
end

def m8
    a = [source(8.1), 1]
    b = a << source(8.2)
    sink(a[0]) # $ hasValueFlow=8.1 $ hasValueFlow=8.2
    sink(a[1]) # $ hasValueFlow=8.2
    sink(b[0]) # $ hasValueFlow=8.1 $ hasValueFlow=8.2
    sink(b[1]) # $ hasValueFlow=8.2
end

def m9(i)
    a = [0, source(9), 2]
    b, c, d = a
    sink(b)
    sink(c) # $ hasValueFlow=9
    sink(d)
end

def m10(i)
    a = [0, source(10), 2]
    b = a[0, 2]
    sink(b[0])
    sink(b[1]) # $ hasValueFlow=10
    sink(b[i]) # $ hasValueFlow=10
end

def m11(i)
    a = [0, source(11), 2]
    b = a[0..2] # inclusive range
    sink(b[0])
    sink(b[1]) # $ hasValueFlow=11
    sink(b[2])
    sink(b[i]) # $ hasValueFlow=11

    a = [0, source(11.1), source(11.2)]
    b = a[0...2] # exclusive range
    sink b[0]
    sink b[1] # $ hasValueFlow=11.1
    sink b[2]

    a = [0, source(11.1), 1, source(11.2)]
    b = a[1 .. -2] # we can't model negative ranges precisely
    sink b[0] # $ hasValueFlow=11.1 $ hasValueFlow=11.2
    sink b[1] # $ hasValueFlow=11.1 $ hasValueFlow=11.2

    b = a[-2 .. -1] # we can't model negative ranges precisely
    sink b[0] # $ hasValueFlow=11.1 $ hasValueFlow=11.2
    sink b[1] # $ hasValueFlow=11.1 $ hasValueFlow=11.2
end

def m12(i)
    a = [0, 1]
    a[0, 1] = source(12)
    sink(a[0]) # $ hasValueFlow=12
    sink(a[1]) # $ hasValueFlow=12
    sink(a[i]) # $ hasValueFlow=12
end

def m13(i)
    a = [0, 1]
    a[0, 1] = [0, source(13), 2]
    sink(a[0]) # $ hasValueFlow=13
    sink(a[1]) # $ hasValueFlow=13
    sink(a[i]) # $ hasValueFlow=13
end

def m14(i)
    a = [0, 1]
    a[0..1] = source(14)
    sink(a[0]) # $ hasValueFlow=14
    sink(a[1]) # $ hasValueFlow=14
    sink(a[i]) # $ hasValueFlow=14
end

def m15(i)
    a = [0, 1]
    a[0..1] = [0, source(15), 2]
    sink(a[0]) # $ hasValueFlow=15
    sink(a[1]) # $ hasValueFlow=15
    sink(a[i]) # $ hasValueFlow=15
end

def m16
    a = [0, 1, source(16)]
    a.all? do |x|
        sink x # $ hasValueFlow=16
    end
end

def m17
    a = [0, 1, source(17)]
    a.any? do |x|
        sink x # $ hasValueFlow=17
    end
end

def m18
    a = [source(18.1), 1]
    b = a.append(source(18.2), source(18.3))
    sink a[0] # $ hasValueFlow=18.1 $ hasValueFlow=18.2 $ hasValueFlow=18.3
    sink a[2] # $ hasValueFlow=18.2 $ hasValueFlow=18.3
    sink b[0] # $ hasValueFlow=18.1 $ hasValueFlow=18.2 $ hasValueFlow=18.3
    sink b[2] # $ hasValueFlow=18.2 $ hasValueFlow=18.3
end

def m19
    a = ["a", 0]
    b = ["b", 1]
    c = ["c", source(19)]
    d = [a, b, c]
    sink (d.assoc("a")[0]) # $ hasValueFlow=19
    sink (d.assoc("c")[0]) # $ hasValueFlow=19
end

def m20(i)
    a = [0, source(20), 2]
    sink(a.at(0))
    sink(a.at(1)) # $ hasValueFlow=20
    sink(a.at(2))
    sink(a.at(i)) # $ hasValueFlow=20
end

def m21
    a = [0, 1, source(21)]
    b = a.bsearch do |x|
        sink x # $ hasValueFlow=21
    end
    sink b # $ hasValueFlow=21
end

def m22
    a = [0, 1, source(22)]
    b = a.bsearch_index do |x|
        sink x # $ hasValueFlow=22
    end
    sink b
end

def m23
    a = [0, 1, source(23)]
    a.chunk do |x|
        sink x # $ hasValueFlow=23
    end
end

def m24
    a = [0, 1, source(24.1), source(24.2)]
    b = a.chunk_while do |x, y|
        sink x # $ hasValueFlow=24.1 $ hasValueFlow=24.2
        sink y # $ hasValueFlow=24.1 $ hasValueFlow=24.2
        x > y
    end
end

def m25
    a = [0, 1, source(25)]
    b = a.clear()
    sink(a[2])
    sink(b[2])
end

def m26
    a = [0, 1, source(26.1)]
    b = a.collect do |x|
        sink x # $ hasValueFlow=26.1
        source 26.2
    end
    sink b[0] # $ hasValueFlow=26.2
end

def m27
    a = [0, 1, source(27.1)]
    b = a.collect! do |x|
        sink x # $ hasValueFlow=27.1
        source 27.2
    end
    sink a[0] # $ hasValueFlow=27.2
    sink b[0] # $ hasValueFlow=27.2
end

def m28
    a = [0, 1, source(28.1)]
    b = a.collect_concat do |x|
        sink x # $ hasValueFlow=28.1
        [x, source(28.2)]
    end
    sink(b[0]) # $ hasValueFlow=28.1 $ hasValueFlow=28.2
    b = a.collect_concat do |x|
        sink(x) # $ hasValueFlow=28.1
        source(28.2)
    end
    sink b[0] # $ hasValueFlow=28.2
end

def m29
    a = [0, 1, source(29)]
    b = a.combination(1) do |x|
        sink(x[0]) # $ hasValueFlow=29
    end
    sink b[0]
    sink b[2] # $ hasValueFlow=29
end

def m30
    a = [0, 1, source(30)]
    b = a.compact
    sink(b[0]) # $ hasValueFlow=30
end

def m31
    a = [0, 1, source(31)]
    b = a.compact!
    sink a[0] # $ hasValueFlow=31
    sink b[0] # $ hasValueFlow=31
end

def m32
    a = [0, 1, source(32.1)]
    b = [0, 1, source(32.2)]
    a.concat(b)
    sink(a[0]) # $ hasValueFlow=32.2
    sink(a[2]) # $ hasValueFlow=32.1 $ hasValueFlow=32.2
end

def m33
    a = [0, 1, source(33)]
    a.count do |x|
        sink x # $ hasValueFlow=33
    end
end

def m34
    a = [0, 1, source(34)]
    a.cycle(2) do |x|
        sink x # $ hasValueFlow=34
    end
end

def m35
    a = [0, 1, source(35)]
    b = a.deconstruct
    sink b[0]
    sink b[1]
    sink b[2] # $ hasValueFlow=35
end

def m36
    a = [0, 1, source(36.1)]
    b = a.delete(2) { source(36.2) }
    sink b # $ hasValueFlow=36.1 $ hasValueFlow=36.2
    sink a[0] # $ hasValueFlow=36.1
    sink a[1] # $ hasValueFlow=36.1
    sink a[2] # $ hasValueFlow=36.1
end

def m37(i)
    a = [0, 1, source(37.1), source(37.2)]
    b = a.delete_at(2)
    sink b # $ hasValueFlow=37.1
    sink a[2] # $ hasValueFlow=37.2

    a = [0, 1, source(37.1), source(37.2)]
    b = a.delete_at(i)
    sink b # $ hasValueFlow=37.1 $ hasValueFlow=37.2
    sink a[0] # $ hasValueFlow=37.1 $ hasValueFlow=37.2
    sink a[2] # $ hasValueFlow=37.1 $ hasValueFlow=37.2
end

def m38
    a = [0, 1, source(38)]
    b = a.delete_if do |x|
        sink x # $ hasValueFlow=38
    end
    sink b[0] # $ hasValueFlow=38
    sink a[0] # $ hasValueFlow=38
    sink a[1] # $ hasValueFlow=38
    sink a[2] # $ hasValueFlow=38
end

def m39
    a = [0, 1, source(39)]
    b = a.difference([1])
    sink(b[0]) # $ hasValueFlow=39
end

def m40(i)
    a = [0, 1, source(40.1), [0, source(40.2)]]
    sink(a.dig(0))
    sink(a.dig(2)) # $ hasValueFlow=40.1
    sink(a.dig(i)) # $ hasValueFlow=40.1
    sink(a.dig(3,0))
    sink(a.dig(3,1)) # $ hasValueFlow=40.2
end

def m41
    a = [0, 1, source(41.1)]
    b = a.detect(-> { source(41.2) }) do |x|
        sink x # $ hasValueFlow=41.1
    end
    sink b # $ hasValueFlow=41.1 $ hasValueFlow=41.2
end

def m42(i)
    a = [0, 1, source(42.1), source(42.2)]
    b = a.drop(i)
    sink(b[0]) # $ hasValueFlow=42.1 # $ hasValueFlow=42.2
    b = a.drop(1)
    sink(b[0])
    sink(b[1]) # $ hasValueFlow=42.1
    sink(b[i]) # $ hasValueFlow=42.1 # $ hasValueFlow=42.2
    a[i] = source(42.3)
    b = a.drop(1)
    sink(b[1]) # $ hasValueFlow=42.1 # $ hasValueFlow=42.3
    c = b.drop(100)
    sink(c[1]) # $ hasValueFlow=42.3
end

def m43
    a = [0, 1, source(43.1), source(43.2)]
    b = a.drop_while do |x|
        sink x # $ hasValueFlow=43.1 # $ hasValueFlow=43.2
    end
    sink(b[0]) # $ hasValueFlow=43.1 # $ hasValueFlow=43.2
end

def m44
    a = [0, 1, source(44)]
    b = a.each do |x|
        sink x # $ hasValueFlow=44
    end
    sink(b[2]) # $ hasValueFlow=44
end

def m45
    a = [0, 1, source(45)]
    b = for x in a # desugars to an `each` call
        sink x # $ hasValueFlow=45
    end
    sink x # $ hasValueFlow=45
    sink(b[2]) # $ hasValueFlow=45
end

def m46
    a = [0, 1, source(46)]
    a.each_cons(2) do |x|
        sink (x[0]) # $ hasValueFlow=46
    end
end

def m47
    a = [0, 1, source(47)]
    b = a.each_entry do |x|
        sink x # $ hasValueFlow=47
    end
    sink(b[2]) # $ hasValueFlow=47
end

def m48
    a = [0, 1, source(48)]
    b = a.each_index do |x|
        sink x
    end
    sink(b[2]) # $ hasValueFlow=48
end

def m49
    a = [0, 1, 2, source(49)]
    a.each_slice(1) do |x|
        sink(x[0]) # $ hasValueFlow=49
    end
end

def m50
    a = [0, 1, 2, source(50)]
    b = a.each_with_index do |x,i|
        sink(x) # $ hasValueFlow=50
        sink(i)
    end
    sink(b[3]) # $ hasValueFlow=50
end

def m51
    a = [0, 1, 2, source(51.1)]
    b = a.each_with_object(source(51.2)) do |x,a|
        sink(x) # $ hasValueFlow=51.1
        sink(a) # $ hasValueFlow=51.2
    end
    sink(b) # $ hasValueFlow=51.2
end

def m52
    a = [0, 1, 2, source(52)]
    b = a.entries
    sink(b[3]) # $ hasValueFlow=52
end

def m53(i)
    a = [0, 1, 2, source(53.1), source(53.2)]
    b = a.fetch(source(53.3)) do |x|
        sink(x) # $ hasValueFlow=53.3
    end
    sink(b) # $ hasValueFlow=53.1 $ hasValueFlow=53.2
    b = a.fetch(3)
    sink b # $ hasValueFlow=53.1
    b = a.fetch(3, source(53.3))
    sink b # $ hasValueFlow=53.1 $ hasValueFlow=53.3
    b = a.fetch(100, source(53.3))
    sink b # $ hasValueFlow=53.3
    b = a.fetch(i, source(53.3))
    sink b # $ hasValueFlow=53.1 $ hasValueFlow=53.2 $ hasValueFlow=53.3
end

def m54
    a = [0, 1, 2, source(54.1)]
    a.fill(source(54.2), 1, 1)
    sink(a[3]) # $ hasValueFlow=54.1 $ hasValueFlow=54.2
    a.fill(source(54.3))
    sink(a[0]) # $ hasValueFlow=54.3
    a.fill do |i|
        source(54.4)
    end
    sink(a[0]) # $ hasValueFlow=54.4
    a.fill(2) do |i|
        source(54.5)
    end
    sink(a[0]) # $ hasValueFlow=54.4 $ hasValueFlow=54.5
end

def m55
    a = [0, 1, 2, source(55)]
    b = a.filter do |x|
        sink(x) # $ hasValueFlow=55
    end
    sink(b[0]) # $ hasValueFlow=55
end

def m56
    a = [0, 1, 2, source(56)]
    b = a.filter_map do |x|
        sink(x) # $ hasValueFlow=56
    end
    sink(b[0]) # $ hasValueFlow=56
end

def m57
    a = [0, 1, 2, source(57)]
    b = a.filter! do |x|
        sink(x) # $ hasValueFlow=57
        x > 2
    end
    sink(a[0]) # $ hasValueFlow=57
    sink(b[0]) # $ hasValueFlow=57
end

def m58
    a = [0, 1, 2, source(58.1)]
    b = a.find(-> { source(58.2) }) do |x|
        sink(x) # $ hasValueFlow=58.1
    end
    sink(b) # $ hasValueFlow=58.1 $ hasValueFlow=58.2
end

def m59
    a = [0, 1, 2, source(59)]
    b = a.find_all do |x|
        sink(x) # $ hasValueFlow=59
    end
    sink(b[0]) # $ hasValueFlow=59
end

def m60
    a = [0, 1, 2, source(60)]
    a.find_index do |x|
        sink(x) # $ hasValueFlow=60
    end
end

def m61(i)
    a = [source(61.1), 1, 2, source(61.2)]
    a[i] = source(61.3)
    sink(a.first) # $ hasValueFlow=61.1 $ hasValueFlow=61.3
    b = a.first(2)
    sink(b[0]) # $ hasValueFlow=61.1 $ hasValueFlow=61.3
    sink(b[4]) # $ hasValueFlow=61.3
    c = a.first(i)
    sink(c[0]) # $ hasValueFlow=61.1 $ hasValueFlow=61.3
    sink(c[3]) # $ hasValueFlow=61.2 $ hasValueFlow=61.3
end

def m62
    a = [0, 1, source(62.1)]
    b = a.flat_map do |x|
        sink(x) # $ hasValueFlow=62.1
        [x, source(62.2)]
    end
    sink(b[0]) # $ hasValueFlow=62.1 $ hasValueFlow=62.2
    b = a.flat_map do |x|
        sink(x) # $ hasValueFlow=62.1
        source(62.2)
    end
    sink b[0] # $ hasValueFlow=62.2
end

def m63
    a = [0, 1, [2, source(63)]]
    b = a.flatten
    sink(b[0]) # $ hasValueFlow=63
end

def m64
    a = [0, 1, [2, source(64)]]
    sink(a[2][1]) # $ hasValueFlow=64
    b = a.flatten!
    sink(a[0]) # $ hasValueFlow=64
    sink(a[2][1]) # $ SPURIOUS: hasValueFlow=64
    sink(b[0]) # $ hasValueFlow=64
    sink(b[2][1]) # $ SPURIOUS: hasValueFlow=64
end

def m65
    a = [0, 1, 2, source(65.1)]
    b = a.grep(/.*/)
    sink(b[0]) # $ hasValueFlow=65.1
    b = a.grep(/.*/) do |x|
        sink x # $ hasValueFlow=65.1
        source(65.2)
    end
    sink(b[0]) # $ hasValueFlow=65.2
end

def m66
    a = [0, 1, 2, source(66.1)]
    b = a.grep_v(/A/)
    sink(b[0]) # $ hasValueFlow=66.1
    b = a.grep_v(/A/) do |x|
        sink x # $ hasValueFlow=66.1
        source(66.2)
    end
    sink(b[0]) # $ hasValueFlow=66.2
end

def m67
    a = [0, 1, 2, source(67.1)]
    b = a.group_by do |x|
        sink x # $ hasValueFlow=67.1
        source 67.2
    end
    sink b
end

def m68
    a = [0, 1, 2, source(68)]
    a.index do |x|
        sink x # $ hasValueFlow=68
    end
end

def m69
    a = [source(69.1), 1, source(69.2)]
    b = a.inject do |x, y|
        sink x # $ hasValueFlow=69.1
        sink y # $ hasValueFlow=69.2
        source 69.3
    end
    sink b # $ hasValueFlow=69.3
    c = a.inject(0) do |x, y|
        sink x
        sink y # $ hasValueFlow=69.1 $ hasValueFlow=69.2
        source 69.3
    end
    sink c # $ hasValueFlow=69.3
end

def m70(i)
    # Known index
    a = [0, 1, source(70.1)]
    b = a.insert(1, source(70.2), source(70.3))
    sink a[0] # 0
    sink a[1] # $ hasValueFlow=70.2
    sink a[2] # $ hasValueFlow=70.3
    sink a[3] # 1
    sink a[4] # $ hasValueFlow=70.1
    sink b[0] # 0
    sink b[1] # $ hasValueFlow=70.2
    sink b[2] # $ hasValueFlow=70.3
    sink b[3] # 1
    sink b[4] # $ hasValueFlow=70.1

    # Unknown index
    c = [0, 1, source(70.1)]
    d = c.insert(i, source(70.4), source(70.5))
    sink c[0] # $ hasValueFlow=70.1 $ hasValueFlow=70.4 $ hasValueFlow=70.5
    sink d[0] # $ hasValueFlow=70.1 $ hasValueFlow=70.4 $ hasValueFlow=70.5
end

def m71
    a = [0, 1, source(71)]
    b = a.inspect
    # TODO should we model `inspect` as adding a taint step?
    sink b
end

def m72
    a = [0, 1, source(72.1)]
    b = a.intersection([2, 3, source(72.2)], [source(72.3)])
    sink b[0] # $ hasValueFlow=72.1 $ hasValueFlow=72.2 $ hasValueFlow=72.3
end

def m73
    a = [0, 1, source(73)]
    b = a.keep_if do |x|
        sink x # $ hasValueFlow=73
        x > 10
    end
    sink a[0] # $ hasValueFlow=73
    sink b[0] # $ hasValueFlow=73
end

def m74
    a = [1, 2, source(74.1)]
    a[i] = source(74.2)
    sink(a.last) # $ hasValueFlow=74.1 $ hasValueFlow=74.2
    b = a.last(2)
    sink b[0] # $ hasValueFlow=74.1 $ hasValueFlow=74.2
    sink b[4] # $ hasValueFlow=74.1 $ hasValueFlow=74.2
end

def m75
    a = [0, 1, source(75.1)]
    b = a.map do |x|
        sink x # $ hasValueFlow=75.1
        source 75.2
    end
    sink b[0] # $ hasValueFlow=75.2
end

def m76
    a = [0, 1, source(76.1)]
    b = a.map! do |x|
        sink x # $ hasValueFlow=76.1
        source 76.2
    end
    sink b[0] # $ hasValueFlow=76.2
end

def m77
    a = [0, 1, source(77)]

    # No argument or block
    b = a.max
    sink(b) # $ hasValueFlow=77

    # Argument, no block
    c = a.max(3)
    sink(c[0]) # $ hasValueFlow=77

    # Block, no argument
    d = a.max do |x, y|
        sink x # $ hasValueFlow=77
        sink y # $ hasValueFlow=77
        x <=> y
    end
    sink(d) # $ hasValueFlow=77

    # Block & argument
    e = a.max(3) do |x, y|
        sink x # $ hasValueFlow=77
        sink y # $ hasValueFlow=77
        x <=> y
    end
    sink(e[0]) # $ hasValueFlow=77
end

def m78
    a = [0, 1, source(78)]

    # No argument
    b = a.max_by do |x|
        sink x # $ hasValueFlow=78
        x
    end
    sink(b) # $ hasValueFlow=78

    # Argument
    c = a.max_by(3) do |x|
        sink x # $ hasValueFlow=78
        x
    end
    sink(c[0]) # $ hasValueFlow=78
end

def m79
    a = [0, 1, source(79)]

    # No argument or block
    b = a.min
    sink(b) # $ hasValueFlow=79

    # Argument, no block
    c = a.min(3)
    sink(c[0]) # $ hasValueFlow=79

    # Block, no argument
    d = a.min do |x, y|
        sink x # $ hasValueFlow=79
        sink y # $ hasValueFlow=79
        x <=> y
    end
    sink(d) # $ hasValueFlow=79

    # Block & argument
    e = a.min(3) do |x, y|
        sink x # $ hasValueFlow=79
        sink y # $ hasValueFlow=79
        x <=> y
    end
    sink(e[0]) # $ hasValueFlow=79
end

def m80
    a = [0, 1, source(80)]

    # No argument
    b = a.min_by do |x|
        sink x # $ hasValueFlow=80
        x
    end
    sink(b) # $ hasValueFlow=80

    # Argument
    c = a.min_by(3) do |x|
        sink x # $ hasValueFlow=80
        x
    end
    sink(c[0]) # $ hasValueFlow=80
end

def m81
    a = [0, 1, source(81)]

    b = a.minmax
    sink b[0] # $ hasValueFlow=81
    sink b[1] # $ hasValueFlow=81

    c = a.minmax do |x, y|
        sink x # $ hasValueFlow=81
        sink y # $ hasValueFlow=81
        x <=> y
    end
    sink c[0] # $ hasValueFlow=81
    sink c[1] # $ hasValueFlow=81
end

def m82
    a = [0, 1, source(82)]
    b = a.minmax_by do |x|
        sink x # $ hasValueFlow=82
        x
    end
    sink b[0] # $ hasValueFlow=82
    sink b[1] # $ hasValueFlow=82
end

def m83
    a = [0, 1, source(83)]
    a.none? do |x|
        sink x # $ hasValueFlow=83
    end
end

# m84 deleted (was `old_to_s`)

def m85
    a = [0, 1, source(85)]
    a.one? do |x|
        sink x # $ hasValueFlow=85
    end
end

def m86
    a = [0, 1, source(86)]
    b = a.pack 'ccc'
    sink b # $ hasTaintFlow=86
end

def m87
    a = [0, 1, source(87)]
    b = a.partition do |x|
        sink x # $ hasValueFlow=87
        x > 23
    end
    sink b[0][0] # $ hasValueFlow=87
    sink b[1][0] # $ hasValueFlow=87
end

def m88(i)
    a = [0, 1, source(88)]

    b = a.permutation do |x|
        sink x[0] # $ hasValueFlow=88
        sink x[1] # $ hasValueFlow=88
        sink x[2] # $ hasValueFlow=88
    end
    sink b[0]
    sink b[2] # $ hasValueFlow=88

    c = a.permutation(2) do |x|
        sink x[0] # $ hasValueFlow=88
        sink x[1] # $ hasValueFlow=88
    end
    sink c[0]
    sink c[2] # $ hasValueFlow=88

    d = a.permutation(i) do |x|
        sink x[0] # $ hasValueFlow=88
        sink x[1] # $ hasValueFlow=88
    end
    sink c[0]
    sink c[2] # $ hasValueFlow=88
end

def m89
    # N.B. Unlike `take`, we can't precisely model which elements are returned
    # or dropped by `pop`, since we don't track the length of the array.

    a = [0, source(89.1), 2, source(89.2)]
    b = a.pop
    sink b # $ hasValueFlow=89.1 $ hasValueFlow=89.2
    sink a[0]
    sink a[1] # $ hasValueFlow=89.1
    sink a[2]
    sink a[3] # $ hasValueFlow=89.2

    a = [0, source(89.1), 2, source(89.2)]
    b = a.pop(2)
    sink b[0] # $ hasValueFlow=89.1 $ hasValueFlow=89.2
    sink b[1] # $ hasValueFlow=89.1 $ hasValueFlow=89.2
    sink a[0]
    sink a[1] # $ hasValueFlow=89.1
    sink a[2]
    sink a[3] # $ hasValueFlow=89.2
end

def m90
    a = [0, 1, source(90.1)]
    a.prepend(2, 3, source(90.2))
    sink(a[0])
    sink(a[1])
    sink(a[2]) # $ hasValueFlow=90.2
    sink(a[3])
    sink(a[4])
    sink(a[5]) # $ hasValueFlow=90.1
end

def m91(i)
    a = [0, 1, source(91.1)]
    b = [2, source(91.2), 3]
    c = [source(91.3), 4, 5]
    d = a.product b, c
    sink d[0][0] # $ hasValueFlow=91.1 $ hasValueFlow=91.2 $ hasValueFlow=91.3
    sink d[i][i] # $ hasValueFlow=91.1 $ hasValueFlow=91.2 $ hasValueFlow=91.3
end

def m92
    a = [source(92.1), 1]
    b = a.append(source(92.2), source(92.3))
    sink a[0] # $ hasValueFlow=92.1 $ hasValueFlow=92.2 $ hasValueFlow=92.3
    sink a[2] # $ hasValueFlow=92.2 $ hasValueFlow=92.3
    sink b[0] # $ hasValueFlow=92.1 $ hasValueFlow=92.2 $ hasValueFlow=92.3
    sink b[2] # $ hasValueFlow=92.2 $ hasValueFlow=92.3
end

def m93
    a = [0, "a"]
    b = [1, "b"]
    c = [source(93), "c"]
    d = [a, b, c]
    sink(d.rassoc("a")[0]) # $ hasValueFlow=93
    sink(d.rassoc("c")[0]) # $ hasValueFlow=93
end

def m94
    a = [source(94.1), 1, source(94.2)]
    b = a.reduce do |x, y|
        sink x # $ hasValueFlow=94.1
        sink y # $ hasValueFlow=94.2
        x + y
    end
    c = a.reduce(0) do |x, y|
        sink x
        sink y # $ hasValueFlow=94.1 $ hasValueFlow=94.2
        x + y
    end
end

def m95
    a = [0, 1, source(95)]
    b = a.reject do |x|
        sink x # $ hasValueFlow=95
        x > 10
    end
    sink b[0] # $ hasValueFlow=95
end

def m96
    a = [0, 1, source(96)]
    b = a.reject! do |x|
        sink x # $ hasValueFlow=96
        x > 10
    end
    sink a[0] # $ hasValueFlow=96
    sink b[0] # $ hasValueFlow=96
end

def m97
    a = [0, 1, source(97)]
    b = a.repeated_combination(2) do |x|
        sink x[0] # $ hasValueFlow=97
        sink x[1] # $ hasValueFlow=97
    end
    sink b[0]
    sink b[2] # $ hasValueFlow=97
end

def m98
    a = [0, 1, source(98)]
    b = a.repeated_permutation(2) do |x|
        sink x[0] # $ hasValueFlow=98
        sink x[1] # $ hasValueFlow=98
    end
    sink b[0]
    sink b[2] # $ hasValueFlow=98
end


def m99
    a = [0, 1, 2, source(99.1)]
    b = a.replace([source(99.2)])
    sink(a[0]) # $ hasValueFlow=99.2
    sink(b[0]) # $ hasValueFlow=99.2
end

def m100
    a = [0, 1, source(100.1), source(100.2)]
    b = a.reverse
    sink b[0] # $ hasValueFlow=100.1 $ hasValueFlow=100.2
    sink b[2] # $ hasValueFlow=100.1 $ hasValueFlow=100.2
    sink b[3] # $ hasValueFlow=100.1 $ hasValueFlow=100.2
    sink a[0]
    sink a[2] # $ hasValueFlow=100.1
    sink a[3] # $ hasValueFlow=100.2
end

def m101
    a = [0, 1, source(101.1), source(101.2)]
    b = a.reverse!
    sink b[0] # $ hasValueFlow=101.1 $ hasValueFlow=101.2
    sink b[2] # $ hasValueFlow=101.1 $ hasValueFlow=101.2
    sink b[3] # $ hasValueFlow=101.1 $ hasValueFlow=101.2
    sink a[0] # $ hasValueFlow=101.1 $ hasValueFlow=101.2
    sink a[2] # $ hasValueFlow=101.1 $ hasValueFlow=101.2
    sink a[3] # $ hasValueFlow=101.1 $ hasValueFlow=101.2
end

def m102
    a = [0, 1, source(102)]
    b = a.reverse_each do |x|
        sink x # $ hasValueFlow=102
    end
    sink(b[2]) # $ hasValueFlow=102
end

def m103
    a = [0, 1, source(103)]
    a.rindex do |x|
        sink x # $ hasValueFlow=103
    end
end

def m104(i)
    # N.B. since we don't track the length of the array, we can't precisely
    # model the new indices for elements that are rotated to the end of the
    # array.
    a = [source(104.1), 1, source(104.2), source(104.3)]

    b = a.rotate
    sink b[0] # $ hasValueFlow=104.1
    sink b[1] # $ hasValueFlow=104.1 $ hasValueFlow=104.2
    sink b[2] # $ hasValueFlow=104.1 $ hasValueFlow=104.3
    sink b[3] # $ hasValueFlow=104.1

    b = a.rotate(2)
    sink b[0] # $ hasValueFlow=104.1 $ hasValueFlow=104.2
    sink b[1] # $ hasValueFlow=104.1 $ hasValueFlow=104.3
    sink b[2] # $ hasValueFlow=104.1
    sink b[3] # $ hasValueFlow=104.1

    b = a.rotate(0)
    sink b[0] # $ hasValueFlow=104.1
    sink b[1]
    sink b[2] # $ hasValueFlow=104.2
    sink b[3] # $ hasValueFlow=104.3

    b = a.rotate(i)
    sink b[0] # $ hasValueFlow=104.1 $ hasValueFlow=104.2 $ hasValueFlow=104.3
    sink b[1] # $ hasValueFlow=104.1 $ hasValueFlow=104.2 $ hasValueFlow=104.3
    sink b[2] # $ hasValueFlow=104.1 $ hasValueFlow=104.2 $ hasValueFlow=104.3
    sink b[3] # $ hasValueFlow=104.1 $ hasValueFlow=104.2 $ hasValueFlow=104.3
end

def m105(i)
    # N.B. since we don't track the length of the array, we can't precisely
    # model the new indices for elements that are rotated to the end of the
    # array.

    a = [source(105.1), 1, source(105.2), source(105.3)]
    b = a.rotate!
    sink a[0] # $ hasValueFlow=105.1
    sink a[1] # $ hasValueFlow=105.1 $ hasValueFlow=105.2
    sink a[2] # $ hasValueFlow=105.1 $ hasValueFlow=105.3
    sink a[3] # $ hasValueFlow=105.1
    sink b[0] # $ hasValueFlow=105.1
    sink b[1] # $ hasValueFlow=105.1 $ hasValueFlow=105.2
    sink b[2] # $ hasValueFlow=105.1 $ hasValueFlow=105.3
    sink b[3] # $ hasValueFlow=105.1

    a = [source(105.1), 1, source(105.2), source(105.3)]
    b = a.rotate!(2)
    sink a[0] # $ hasValueFlow=105.1 $ hasValueFlow=105.2
    sink a[1] # $ hasValueFlow=105.1 $ hasValueFlow=105.3
    sink a[2] # $ hasValueFlow=105.1
    sink a[3] # $ hasValueFlow=105.1
    sink b[0] # $ hasValueFlow=105.1 $ hasValueFlow=105.2
    sink b[1] # $ hasValueFlow=105.1 $ hasValueFlow=105.3
    sink b[2] # $ hasValueFlow=105.1
    sink b[3] # $ hasValueFlow=105.1

    a = [source(105.1), 1, source(105.2), source(105.3)]
    b = a.rotate!(0)
    sink a[0] # $ hasValueFlow=105.1
    sink a[1]
    sink a[2] # $ hasValueFlow=105.2
    sink a[3] # $ hasValueFlow=105.3
    sink b[0] # $ hasValueFlow=105.1
    sink b[1]
    sink b[2] # $ hasValueFlow=105.2
    sink b[3] # $ hasValueFlow=105.3

    a = [source(105.1), 1, source(105.2), source(105.3)]
    b = a.rotate!(i)
    sink a[0] # $ hasValueFlow=105.1 $ hasValueFlow=105.2 $ hasValueFlow=105.3
    sink a[1] # $ hasValueFlow=105.1 $ hasValueFlow=105.2 $ hasValueFlow=105.3
    sink a[2] # $ hasValueFlow=105.1 $ hasValueFlow=105.2 $ hasValueFlow=105.3
    sink a[3] # $ hasValueFlow=105.1 $ hasValueFlow=105.2 $ hasValueFlow=105.3
    sink b[0] # $ hasValueFlow=105.1 $ hasValueFlow=105.2 $ hasValueFlow=105.3
    sink b[1] # $ hasValueFlow=105.1 $ hasValueFlow=105.2 $ hasValueFlow=105.3
    sink b[2] # $ hasValueFlow=105.1 $ hasValueFlow=105.2 $ hasValueFlow=105.3
    sink b[3] # $ hasValueFlow=105.1 $ hasValueFlow=105.2 $ hasValueFlow=105.3
end

def m106
    a = [0, 1, 2, source(106)]
    b = a.select do |x|
        sink(x) # $ hasValueFlow=106
    end
    sink(b[0]) # $ hasValueFlow=106
end

def m107
    a = [0, 1, source(107)]
    b = a.select! do |x|
        sink x # $ hasValueFlow=107
        x > 10
    end
    sink a[0] # $ hasValueFlow=107
    sink b[0] # $ hasValueFlow=107
end

def m108(i)
    a = [source(108.1), 1, source(108.2)]
    b = a.shift
    sink b # $ hasValueFlow=108.1
    sink a[0]
    sink a[1] # $ hasValueFlow=108.2
    sink a[2]

    a = [source(108.1), 1, source(108.2)]
    b = a.shift(2)
    sink b[0] # $ hasValueFlow=108.1
    sink b[1]
    sink a[0] # $ hasValueFlow=108.2
    sink a[1]
    sink a[2]

    a = [source(108.1), 1, source(108.2)]
    b = a.shift(i)
    sink b[0] # $ hasValueFlow=108.1 $ hasValueFlow=108.2
    sink b[1] # $ hasValueFlow=108.1 $ hasValueFlow=108.2
    sink a[0] # $ hasValueFlow=108.1 $ hasValueFlow=108.2
    sink a[1] # $ hasValueFlow=108.1 $ hasValueFlow=108.2
    sink a[2] # $ hasValueFlow=108.1 $ hasValueFlow=108.2
end

def m109
    a = [0, 1, source(109)]
    b = a.shuffle
    sink a[0]
    sink a[1]
    sink a[2] # $ hasValueFlow=109
    sink b[0] # $ hasValueFlow=109
    sink b[1] # $ hasValueFlow=109
    sink b[2] # $ hasValueFlow=109
end

def m110
    a = [0, 1, source(110)]
    b = a.shuffle!
    sink a[0] # $ hasValueFlow=110
    sink a[1] # $ hasValueFlow=110
    sink a[2] # $ hasValueFlow=110
    sink b[0] # $ hasValueFlow=110
    sink b[1] # $ hasValueFlow=110
    sink b[2] # $ hasValueFlow=110
end

def m111(i)
    a = [0, 1, source(111.1), 2, source(111.2)]

    b = a.slice 4
    sink b # $ hasValueFlow=111.2

    b = a.slice(-1)
    sink b # $ hasValueFlow=111.1 $ hasValueFlow=111.2

    b = a.slice i
    # If `i` is an integer:
    sink b # $ hasValueFlow=111.1 $ hasValueFlow=111.2
    # If `i` is a range/aseq:
    sink b[0] # $ hasValueFlow=111.1 $ hasValueFlow=111.2

    b = a.slice(2, 3)
    sink b[0] # $ hasValueFlow=111.1
    sink b[1]
    sink b[2] # $ hasValueFlow=111.2

    b = a.slice(1, i) # unknown range
    sink b[0] # $ hasValueFlow=111.1 $ hasValueFlow=111.2
    sink b[1] # $ hasValueFlow=111.1 $ hasValueFlow=111.2

    b = a.slice(2..3) # inclusive range
    sink b[0] # $ hasValueFlow=111.1
    sink b[1]
    sink b[2]

    b = a.slice(2...4) # exclusive range
    sink b[0] # $ hasValueFlow=111.1
    sink b[1]
    sink b[2]

    b = a.slice(3..i) # unknown range
    sink b[0] # $ hasValueFlow=111.1 $ hasValueFlow=111.2
    sink b[1] # $ hasValueFlow=111.1 $ hasValueFlow=111.2

    b = a.slice(1 .. -1) # unknown range
    sink b[0] # $ hasValueFlow=111.1 $ hasValueFlow=111.2
    sink b[1] # $ hasValueFlow=111.1 $ hasValueFlow=111.2

    b = a.slice(..2)
    sink b[0]
    sink b[1]
    sink b[2] # $ hasValueFlow=111.1

    b = a.slice(2..) # unknown range
    sink b[0] # $ hasValueFlow=111.1 $ hasValueFlow=111.2
    sink b[0] # $ hasValueFlow=111.1 $ hasValueFlow=111.2
    sink b[1] # $ hasValueFlow=111.1 $ hasValueFlow=111.2
end

def m112(i)
    a = [0, 1, source(112.1), 2, source(112.2)]
    b = a.slice!(2)
    sink b # $ hasValueFlow=112.1
    sink a[0]
    sink a[1]
    sink a[2]
    sink a[3] # $ hasValueFlow=112.2

    a = [0, 1, source(112.1), 2, source(112.2)]
    b = a.slice!(i)
    sink a[0] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[1] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[2] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[3] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    # If `i` is an integer:
    sink b # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    # If `i` is a range/aseq:
    sink b[0] # $ hasValueFlow=112.1 $ hasValueFlow=112.2

    a = [0, 1, source(112.1), 2, source(112.2)]
    b = a.slice!(2, 3)
    sink b[0] # $ hasValueFlow=112.1
    sink b[1]
    sink b[2] # $ hasValueFlow=112.2
    sink a[0]
    sink a[1]
    sink a[2]
    sink a[3]
    sink a[4]

    a = [0, 1, source(112.1), 2, source(112.2)]
    b = a.slice!(2..3) # inclusive range
    sink b[0] # $ hasValueFlow=112.1
    sink b[1]
    sink b[2]
    sink a[0]
    sink a[1]
    sink a[2] # $ hasValueFlow=112.2
    sink a[3]
    sink a[4]

    a = [0, 1, source(112.1), 2, source(112.2)]
    b = a.slice!(2...4) # exclusive range
    sink b[0] # $ hasValueFlow=112.1
    sink b[1]
    sink b[2]
    sink a[0]
    sink a[1]
    sink a[2] # $ hasValueFlow=112.2
    sink a[3]
    sink a[4]

    a = [0, 1, source(112.1), 2, source(112.2)]
    b = a.slice!(2, i) # unknown range
    sink b[0] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink b[1] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink b[2] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[0] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[1] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[2] # $ hasValueFlow=112.1 $ hasValueFlow=112.2

    a = [0, 1, source(112.1), 2, source(112.2)]
    b = a.slice!(2..i) # unknown range
    sink b[0] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink b[1] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink b[2] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[0] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[1] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[2] # $ hasValueFlow=112.1 $ hasValueFlow=112.2

    a = [0, 1, source(112.1), 2, source(112.2)]
    b = a.slice!(2 .. -1) # unknown range
    sink b[0] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink b[1] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink b[2] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[0] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[1] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[2] # $ hasValueFlow=112.1 $ hasValueFlow=112.2

    a = [0, 1, source(112.1), 2, source(112.2)]
    b = a.slice!(..2)
    sink b[0]
    sink b[1]
    sink b[2] # $ hasValueFlow=112.1
    sink a[0]
    sink a[1] # $ hasValueFlow=112.2
    sink a[2]

    a = [0, 1, source(112.1), 2, source(112.2)]
    b = a.slice!(3..) # unknown range
    sink b[0] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink b[1] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink b[2] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[0] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[1] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
    sink a[2] # $ hasValueFlow=112.1 $ hasValueFlow=112.2
end

def m113
    a = [0, 1, source(113)]
    b = a.slice_after do |x|
        sink x # $ hasValueFlow=113
        x > 41
    end
end

def m114
    a = [0, 1, source(114)]
    b = a.slice_before do |x|
        sink x # $ hasValueFlow=114
        x > 41
    end
end

def m115
    a = [0, 1, source(115)]
    b = a.slice_when do |x, y|
        sink x # $ hasValueFlow=115
        sink y # $ hasValueFlow=115
    end
end

def m116
    a = [0, 1, source(116)]
    b = a.sort
    sink b[0] # $ hasValueFlow=116
    sink b[1] # $ hasValueFlow=116
    c = a.sort do |x, y|
        sink x # $ hasValueFlow=116
        sink y # $ hasValueFlow=116
        y <=> x
    end
    sink c[0] # $ hasValueFlow=116
    sink c[1] # $ hasValueFlow=116
end

def m117
    a = [0, 1, source(117)]
    b = a.sort!
    sink b[0] # $ hasValueFlow=117
    sink b[1] # $ hasValueFlow=117
    sink a[0] # $ hasValueFlow=117
    sink a[1] # $ hasValueFlow=117

    a = [0, 1, source(117)]
    b = a.sort! do |x, y|
        sink x # $ hasValueFlow=117
        sink y # $ hasValueFlow=117
        y <=> x
    end
    sink b[0] # $ hasValueFlow=117
    sink b[1] # $ hasValueFlow=117
    sink a[0] # $ hasValueFlow=117
    sink a[1] # $ hasValueFlow=117
end

def m118
    a = [0, 1, source(118)]
    b = a.sort_by do |x|
        sink x # $ hasValueFlow=118
        -x
    end
    sink b[0] # $ hasValueFlow=118
    sink b[1] # $ hasValueFlow=118
end

def m119
    a = [0, 1, source(119)]
    b = a.sort_by! do |x|
        sink x # $ hasValueFlow=119
        -x
    end
    sink a[0] # $ hasValueFlow=119
    sink a[1] # $ hasValueFlow=119
    sink b[0] # $ hasValueFlow=119
    sink b[1] # $ hasValueFlow=119
end

def m120
    a = [0, 1, source(119)]
    b = a.sum do |x|
        sink x # $ hasValueFlow=119
        x * x
    end
end

def m121(i)
    a = [0, 1, source(121.1), source(121.2)]
    b = a.take(i)
    sink(b[0])
    sink(b[1])
    sink(b[2]) # $ hasValueFlow=121.1
    sink(b[3]) # $ hasValueFlow=121.2
    b = a.take(3)
    sink(b[0])
    sink(b[1])
    sink(b[2]) # $ hasValueFlow=121.1
    sink(b[3])
    sink(b[i]) # $ hasValueFlow=121.1
    b = a.take(133)
    sink(b[0])
    sink(b[1])
    sink(b[2]) # $ hasValueFlow=121.1
    sink(b[3]) # $ hasValueFlow=121.2
    sink(b[i]) # $ hasValueFlow=121.1 $ hasValueFlow=121.2
    a[i] = source(121.3)
    b = a.take(3)
    sink(b[2]) # $ hasValueFlow=121.1 # $ hasValueFlow=121.3
end

def m122
    a = [0, 1, source(122)]
    b = a.take_while do |x|
        sink x # $ hasValueFlow=122
        x < 43
    end
    sink b[0]
    sink b[1]
    sink b[2] # $ hasValueFlow=122
end

# TODO: test method (m123) for `tally`, once we have flow through hashes

def m124
    a = [0, 1, 2, source(124)]
    b = a.to_a
    sink(b[3]) # $ hasValueFlow=124
end

def m125
    a = [0, 1, source(125)]
    b = a.to_ary
    sink b[0]
    sink b[1]
    sink b[2] # $ hasValueFlow=125
end

# TODO: test method (m126) for `to_h`, once we have flow through hashes

def m127
    a = [0, 1, source(127)]
    b = a.old_to_s
    # TODO should we model `old_to_s` as adding a taint step?
    sink b
end

def m128
    a = [[0, source(128.1)], [1, source(128.2)], [2, source(128.3)]]
    b = a.transpose
    sink b[0][0]
    sink b[0][1]
    sink b[0][2]
    sink b[1][0] # $ hasValueFlow=128.1
    sink b[1][1] # $ hasValueFlow=128.2
    sink b[1][2] # $ hasValueFlow=128.3
end

def m129
    a = [0, 1, source(129.1)]
    b = [2, source(129.2)]
    c = [3, source(129.3)]
    d = a.union(b, c)
    sink d[0] # $ hasValueFlow=129.1 $ hasValueFlow=129.2 $ hasValueFlow=129.3
    sink d[1] # $ hasValueFlow=129.1 $ hasValueFlow=129.2 $ hasValueFlow=129.3
    sink d[2] # $ hasValueFlow=129.1 $ hasValueFlow=129.2 $ hasValueFlow=129.3
end

def m130
    a = [0, 1, 2, source(130.1), source(130.2)]

    b = a.uniq
    sink b[0] # $ hasValueFlow=130.1 $ hasValueFlow=130.2
    sink b[1] # $ hasValueFlow=130.1 $ hasValueFlow=130.2

    c = a.uniq do |x|
        sink x # $ hasValueFlow=130.1 $ hasValueFlow=130.2
        x % 7
    end
    sink c[0] # $ hasValueFlow=130.1 $ hasValueFlow=130.2
end

def m131
    a = [0, 1, source(131.1), source(131.2)]
    b = a.uniq!
    sink b[0] # $ hasValueFlow=131.1 $ hasValueFlow=131.2
    sink b[1] # $ hasValueFlow=131.1 $ hasValueFlow=131.2
    sink a[0] # $ hasValueFlow=131.1 $ hasValueFlow=131.2
    sink a[1] # $ hasValueFlow=131.1 $ hasValueFlow=131.2

    a = [0, 1, source(131.1), source(131.2)]
    b = a.uniq! do |x|
        sink x # $ hasValueFlow=131.1 $ hasValueFlow=131.2
        x % 7
    end
    sink b[0] # $ hasValueFlow=131.1 $ hasValueFlow=131.2
    sink b[1] # $ hasValueFlow=131.1 $ hasValueFlow=131.2
    sink a[0] # $ hasValueFlow=131.1 $ hasValueFlow=131.2
    sink a[1] # $ hasValueFlow=131.1 $ hasValueFlow=131.2
end

def m132
    a = [0, 1, source(132.1)]
    a.unshift(2, 3, source(132.2))
    sink(a[0])
    sink(a[1])
    sink(a[2]) # $ hasValueFlow=132.2
    sink(a[3])
    sink(a[4])
    sink(a[5]) # $ hasValueFlow=132.1
end

def m133(i)
    a = [0, source(133.1), 2, source(133.2)]

    b = a.values_at(0, 1, 2, 1) # all args are known indices
    sink b[0]
    sink b[1] # $ hasValueFlow=133.1
    sink b[2]
    sink b[3] # $ hasValueFlow=133.1

    b = a.values_at(0, i) # unknown index
    sink b[0] # $ hasValueFlow=133.1 $ hasValueFlow=133.2
    sink b[1] # $ hasValueFlow=133.1 $ hasValueFlow=133.2

    b = a.values_at(-1, 0) # unknown index
    sink b[0] # $ hasValueFlow=133.1 $ hasValueFlow=133.2
    sink b[1] # $ hasValueFlow=133.1 $ hasValueFlow=133.2

    b = a.values_at(0..1, 3) # we don't precisely model indices if any of the arguments are ranges
    sink b[0] # $ hasValueFlow=133.1 $ hasValueFlow=133.2
    sink b[1] # $ hasValueFlow=133.1 $ hasValueFlow=133.2
    sink b[2] # $ hasValueFlow=133.1 $ hasValueFlow=133.2
    sink b[3] # $ hasValueFlow=133.1 $ hasValueFlow=133.2
end

def m134
    a = [0, 1, source(134.1)]
    b = [2, source(134.2), 3]
    c = [source(134.3), 4, 5]
    d = a.zip(b, c)
    sink d[0][0]
    sink d[0][2] # $ hasValueFlow=134.3
    sink d[1][1] # $ hasValueFlow=134.2
    sink d[2][0] # $ hasValueFlow=134.1
    a.zip(b, c) do |x|
        sink x[0] # $ hasValueFlow=134.1
        sink x[1] # $ hasValueFlow=134.2
        sink x[2] # $ hasValueFlow=134.3
    end
end

def m135
    a = [0, 1, source(135.1)]
    b = [2, source(135.2)]
    c = a | b # union
    sink c[0] # $ hasValueFlow=135.1 $ hasValueFlow=135.2
    sink c[1] # $ hasValueFlow=135.1 $ hasValueFlow=135.2
    sink c[2] # $ hasValueFlow=135.1 $ hasValueFlow=135.2
end

def m136(i)
    a = [[0]]
    a[i][0] = source(136.1)
    sink(a[0][0]) # $ hasValueFlow=136.1
    sink(a[0][1])
end
