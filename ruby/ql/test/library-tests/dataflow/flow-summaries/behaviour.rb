def m1
    a = source "a"
    x = a.s1()
    sink x # $ hasValueFlow=a
end

def m2(x)
    a = source "a"
    x.s2(a)
    sink x # $ hasValueFlow=a
end

def m3(x)
    a = source "a"
    s3(a, x)
    sink x # $ hasValueFlow=a
end

def m4
    sink s4("a", "b", "c")
    sink s4(source "a", "b", "c")
    sink s4("a", source "b", "c") # $ hasValueFlow=b SPURIOUS: hasValueFlow=c
    sink s4("a", "b", source "c") # $ hasValueFlow=c
    sink s4(source "a", source "b", source "c") # hasValueFlow=b hasValueFlow=c
end

def m5(x, y, z)
    a = source "a"
    s5(a, x, y, z)
    sink x
    sink y # $ hasValueFlow=a
    sink z # $ hasValueFlow=a
end

def m6
    sink s6(foo: source "a", bar: source "b") # $ MISSING: hasValueFlow=a
end

def m7(x)
    a = source "a"
    s7(a, foo: x)
    sink x # $ hasValueFlow=a
end

def m8
    sink(s8 { source "a" }) # $ hasValueFlow=a
    sink(s8 do # $hasValueFlow=a
        source "a" 
    end)
end

def m9
    s9(source "a") { |x| sink x } # $ hasValueFlow=a
    s9(source "a") do |x|
        sink x # $ hasValueFlow=a
    end
end

def m10
    a = source "a"
    sink s10(a) # $ hasValueFlow=a
    sink s10(0, a) # $ hasValueFlow=a
    sink s10(foo: a) # $ hasValueFlow=a
    sink s10(foo: 0, bar: a) # $ hasValueFlow=a
    sink (a).s10
    sink s10(&a) # $ hasValueFlow=a
end

def m11
    a = source "a"
    sink(s11 { a })
    sink(s11 do
        a
    end)
    f = ->() { a }
    sink s10(&f)
end

def m12(x, y, z, &blk)
    a = source "a"
    a.s12(x, y, foo: z, &blk)
    sink x # $ hasValueFlow=a
    sink y # $ hasValueFlow=a
    sink z # $ hasValueFlow=a
    sink blk
end

def m13
    a = source "a"
    sink s13(a)
    sink s13(foo: a) # $ hasValueFlow=a
    sink s13(foo: 0, bar: a) # $ hasValueFlow=a
    sink a.s13
end

def m14(w, x, y, z)
    a = source "a"
    a.s14(w, foo: x)
    a.s14(foo: y, bar: z)
    sink w
    sink x # $ hasValueFlow=a
    sink y # $ hasValueFlow=a
    sink z # $ hasValueFlow=a
end

def  m15
    a = source "a"
    b = source "b"
    sink s15(**a) # $ SPURIOUS: hasTaintFlow=a MISSING: hasValueFlow=a
    sink s15(0, 1, foo: b, **a) # $ SPURIOUS: hasTaintFlow=a MISSING: hasValueFlow=a
end

def m16
    a = source "a"
    b = source "b"
    h = { a: a, b: 1 }
    sink s16(**h) # $ hasValueFlow=a
    sink s16(a)
    sink s16(a: a) # $ hasValueFlow=a
    sink s16(b: 1)
    sink s16(b: b, **h) # $ hasValueFlow=a hasValueFlow=b
end

def m17(h, x)
    a = source "a"
    s17(a, **h, foo: x)
    sink h # $ hasValueFlow=a
    sink x
end

def m18(x)
    a = source "a"
    s18(a, **h, foo: x)
    sink h
    sink x # $ MISSING: hasValueFlow=a
end
