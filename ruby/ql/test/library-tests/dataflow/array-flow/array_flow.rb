def m0(i)
    a = *source(0)
    sink(a[0]) # $ hasValueFlow=0
    sink(a[1])
    sink(a[i]) # $ hasValueFlow=0
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
    sink(b[0]) # $ hasValueFlow=10
    sink(b[1]) # $ hasValueFlow=10
    sink(b[i]) # $ hasValueFlow=10
end

def m11(i)
    a = [0, source(11), 2]
    b = a[0..2]
    sink(b[0]) # $ hasValueFlow=11
    sink(b[1]) # $ hasValueFlow=11
    sink(b[i]) # $ hasValueFlow=11
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
    a = ["a", 0]
    b = ["b", 1]
    c = ["c", source(18)]
    d = [a, b, c]
    sink (d.assoc("a")[0]) # $ hasValueFlow=18
    sink (d.assoc("c")[0]) # $ hasValueFlow=18
end

def m19(i)
    a = [0, source(19), 2]
    sink(a.at(0))
    sink(a.at(1)) # $ hasValueFlow=19
    sink(a.at(2))
    sink(a.at(i)) # $ hasValueFlow=19
end

def m20
    a = [0, 1, source(20)]
    b = a.bsearch do |x|
        sink x # $ hasValueFlow=20
    end
    sink b # $ hasValueFlow=20
end

def m21
    a = [0, 1, source(21)]
    b = a.bsearch_index do |x|
        sink x # $ hasValueFlow=21
    end
    sink b
end

def m22
    a = [0, 1, source(22)]
    a.clear()
    sink(a[2])
end

def m23
    a = [0, 1, source(23)]
    b = a.collect do |x|
        sink x # $ hasValueFlow=23
        x
    end
    sink(b[0]) # $ hasValueFlow=23
end

def m24
    a = [0, 1, source(24)]
    b = a.collect_concat do |x|
        sink x # $ hasValueFlow=24
        [x, x]
    end
    sink(b[0]) # $ hasValueFlow=24
end

def m25
    a = [0, 1, source(25)]
    a.combination(1) do |x|
        sink(x[0]) # $ hasValueFlow=25
    end
end

def m26
    a = [0, 1, source(26)]
    b = a.compact
    sink(b[0]) # $ hasValueFlow=26
end

def m27
    a = [0, 1, source(27.1)]
    b = [0, 1, source(27.2)]
    a.concat(b)
    sink(a[0]) # $ hasValueFlow=27.2
    sink(a[2]) # $ hasValueFlow=27.1 $ hasValueFlow=27.2
end

def m28
    a = [0, 1, source(28)]
    a.count do |x|
        sink x # $ hasValueFlow=28
    end
end

def m29
    a = [0, 1, source(29)]
    a.cycle(2) do |x|
        sink x # $ hasValueFlow=29
    end
end

def m30
    a = [0, 1, source(30.1)]
    b = a.delete(2) { source(30.2) }
    sink b # $ hasValueFlow=30.1 $ hasValueFlow=30.2
end

def m31
    a = [0, 1, source(31)]
    b = a.delete_at(2)
    sink b # $ hasValueFlow=31
end

def m32
    a = [0, 1, source(32)]
    b = a.delete_if do |x|
        sink x # $ hasValueFlow=32
    end
    sink(b[0]) # $ hasValueFlow=32
end

def m33
    a = [0, 1, source(33)]
    b = a.difference([1])
    sink(b[0]) # $ hasValueFlow=33
end

def m34(i)
    a = [0, 1, source(34.1), [0, source(34.2)]]
    sink(a.dig(0))
    sink(a.dig(2)) # $ hasValueFlow=34.1
    sink(a.dig(i)) # $ hasValueFlow=34.1
    sink(a.dig(3,0))
    sink(a.dig(3,1)) # $ hasValueFlow=34.2
end

def m35
    a = [0, 1, source(35.1)]
    b = a.detect(-> { source(35.2) }) do |x|
        sink x # $ hasValueFlow=35.1
    end
    sink b # $ hasValueFlow=35.1 $ hasValueFlow=35.2
end

def m36(i)
    a = [0, 1, source(36.1), source(36.2)]
    b = a.drop(i)
    sink(b[0]) # $ hasValueFlow=36.1 # $ hasValueFlow=36.2
    b = a.drop(1)
    sink(b[0])
    sink(b[1]) # $ hasValueFlow=36.1
    sink(b[i]) # $ hasValueFlow=36.1 # $ hasValueFlow=36.2
    a[i] = source(36.3)
    b = a.drop(1)
    sink(b[1]) # $ hasValueFlow=36.1 # $ hasValueFlow=36.3
    c = b.drop(100)
    sink(c[1]) # $ hasValueFlow=36.3
end

def m37
    a = [0, 1, source(37.1), source(37.2)]
    b = a.drop_while do |x|
        sink x # $ hasValueFlow=37.1 # $ hasValueFlow=37.2
    end
    sink(b[0]) # $ hasValueFlow=37.1 # $ hasValueFlow=37.2
end

def m38
    a = [0, 1, source(38)]
    b = a.each do |x|
        sink x # $ hasValueFlow=38
    end
    sink(b[2]) # $ hasValueFlow=38
end

def m39
    a = [0, 1, source(39)]
    b = for x in a # desugars to an `each` call
        sink x # $ hasValueFlow=39
    end
    sink x # $ hasValueFlow=39
    sink(b[2]) # $ hasValueFlow=39
end

def m40
    a = [0, 1, source(40)]
    a.each_cons(2) do |x|
        sink (x[0]) # $ hasValueFlow=40
    end
end

def m41
    a = [0, 1, source(41)]
    b = a.each_entry do |x|
        sink x # $ hasValueFlow=41
    end
    sink(b[2]) # $ hasValueFlow=41
end

def m42
    a = [0, 1, source(42)]
    b = a.each_index do |x|
        sink x
    end
    sink(b[2]) # $ hasValueFlow=42
end

def m43
    a = [0, 1, 2, source(43)]
    a.each_slice(1) do |x|
        sink(x[0]) # $ hasValueFlow=43
    end
end

def m44
    a = [0, 1, 2, source(44)]
    b = a.each_with_index do |x,i|
        sink(x) # $ hasValueFlow=44
        sink(i)
    end
    sink(b[3]) # $ hasValueFlow=44
end

def m45
    a = [0, 1, 2, source(45.1)]
    b = a.each_with_object(source(45.2)) do |x,a|
        sink(x) # $ hasValueFlow=45.1
        sink(a) # $ hasValueFlow=45.2
    end
    sink(b) # $ hasValueFlow=45.2
end

def m46(i)
    a = [0, 1, 2, source(46.1)]
    b = a.fetch(source(46.2)) do |x|
        sink(x) # $ hasValueFlow=46.2
    end
    sink(b) # $ hasValueFlow=46.1
end

def m47
    a = [0, 1, 2, source(47.1)]
    a.fill(source(47.2), 1, 1)
    sink(a[3]) # $ hasValueFlow=47.1 $ hasValueFlow=47.2
    a.fill(source(47.3))
    sink(a[0]) # $ hasValueFlow=47.3
    a.fill do |i|
        source(47.4)
    end
    sink(a[0]) # $ hasValueFlow=47.4
    a.fill(2) do |i|
        source(47.5)
    end
    sink(a[0]) # $ hasValueFlow=47.4 $ hasValueFlow=47.5
end

def m48
    a = [0, 1, 2, source(48)]
    b = a.filter do |x|
        sink(x) # $ hasValueFlow=48
    end
    sink(b[0]) # $ hasValueFlow=48
end

def m49
    a = [0, 1, 2, source(49)]
    b = a.filter_map do |x|
        sink(x) # $ hasValueFlow=49
    end
    sink(b[0]) # $ hasValueFlow=49
end

def m50
    a = [0, 1, 2, source(50)]
    b = a.filter! do |x|
        sink(x) # $ hasValueFlow=50
        x > 2
    end
    sink(b[0]) # $ hasValueFlow=50
end

def m51
    a = [0, 1, 2, source(51.1)]
    b = a.find(-> { source(51.2) }) do |x|
        sink(x) # $ hasValueFlow=51.1
    end
    sink(b) # $ hasValueFlow=51.1 $ hasValueFlow=51.2
end

def m52
    a = [0, 1, 2, source(52)]
    b = a.find_all do |x|
        sink(x) # $ hasValueFlow=52
    end
    sink(b[0]) # $ hasValueFlow=52
end

def m53
    a = [0, 1, 2, source(53)]
    a.find_index do |x|
        sink(x) # $ hasValueFlow=53
    end
end

def m54(i)
    a = [source(54.1), 1, 2, source(54.2)]
    a[i] = source(54.3)
    sink(a.first) # $ hasValueFlow=54.1 $ hasValueFlow=54.3
    b = a.first(2)
    sink(b[0]) # $ hasValueFlow=54.1 $ hasValueFlow=54.3
    sink(b[4]) # $ hasValueFlow=54.3
    c = a.first(i)
    sink(c[0]) # $ hasValueFlow=54.1 $ hasValueFlow=54.3
    sink(c[3]) # $ hasValueFlow=54.2 $ hasValueFlow=54.3
end

def m55
    a = [0, 1, 2, source(55.1)]
    b = a.flat_map do |x|
        sink(x) # $ hasValueFlow=55.1
        [x, source(55.2)]
    end
    sink(b[0]) # $ hasValueFlow=55.1 $ hasValueFlow=55.2
end

def m56
    a = [0, 1, [2, source(56)]]
    b = a.flatten
    sink(b[0]) # $ hasValueFlow=56
end

def m57
    a = [0, 1, [2, source(57)]]
    sink(a[2][1]) # $ hasValueFlow=57
    a.flatten!
    sink(a[0]) # $ hasValueFlow=57
    sink(a[2][1]) # $ SPURIOUS: hasValueFlow=57
end

def m58
    a = [0, 1, 2, source(58.1)]
    b = a.grep(/.*/)
    sink(b[0]) # $ hasValueFlow=58.1
    b = a.grep(/.*/) do |x|
        sink x # $ hasValueFlow=58.1
        source(58.2)
    end
    sink(b[0]) # $ hasValueFlow=58.2
end

def m59
    a = [0, 1, 2, source(59.1)]
    b = a.grep_v(/A/)
    sink(b[0]) # $ hasValueFlow=59.1
    b = a.grep_v(/A/) do |x|
        sink x # $ hasValueFlow=59.1
        source(59.2)
    end
    sink(b[0]) # $ hasValueFlow=59.2
end

def m60
    a = [0, 1, 2, source(60)]
    a.index do |x|
        sink x # $ hasValueFlow=60
    end
end

def m61
    a = [0, 1, 2, source(61.1)]
    a.replace([source(61.2)])
    sink(a[0]) # $ hasValueFlow=61.2
end


# TODO: assign appropriate number when reached in the alphabetical ordering
def m2600
    a = [0, 1, source(2600.1)]
    a.prepend(2, 3, source(2600.2))
    sink(a[0])
    sink(a[1])
    sink(a[2]) # $ hasValueFlow=2600.2
    sink(a[3])
    sink(a[4])
    sink(a[5]) # $ hasValueFlow=2600.1
end
