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
    sink s6(foo: (source "a"), bar: (source "b")) # $ hasValueFlow=a
end

def m7(x)
    a = source "a"
    s7(a, foo: x)
    sink x # $ hasValueFlow=a
end

def m8
    sink(s8 { source "a" }) # $ hasValueFlow=a
    sink(s8 do
        source "a" 
    end) # $hasValueFlow=a
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

def m15
    a = source "a"
    b = source "b"
    sink s15(foo: a, bar: b)[:foo] # $ hasValueFlow=a
    sink s15(foo: a, bar: b)[:bar] # $ hasValueFlow=b
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

def m17
    a = source "a"
    b = source "b"
    sink s17(a, b) # $ hasTaintFlow=a $ hasTaintFlow=b
    sink s17(a, b)[0] # $ hasValueFlow=a
    sink s17(a, b)[1] # $ hasValueFlow=b
end

def m18
    a = source "a"
    b = source "b"
    arr = [a, b]
    sink s18(*arr) # $ hasValueFlow=a $ hasValueFlow=b
    sink s18(a) # $ hasValueFlow=a
end

def m19(i)
    a = source "a"
    b = source "b"

    h = {}
    h[0] = a
    h[i] = b

    sink s19(h) # $ hasValueFlow=b
end

def m20(i)
    a = source "a"
    x = s20(a)
    sink x[0] # $ hasValueFlow=a
    sink x[i] # $ hasValueFlow=a
end

def m21(i)
    a = source "a"
    b = source "b"

    h = {}
    h[0] = a
    h[i] = b

    sink s21(h) # $ hasValueFlow=a hasValueFlow=b
end

def m22
    a = source "a"
    x = s22(a)
    sink x[0] # $ hasValueFlow=a
    sink x[i] # $ hasValueFlow=a
end

def m23(i)
    a = source "a"
    b = source "b"
    h = []
    h[0] = a
    h[1] = b
    sink s23(h) # $ hasValueFlow=a
end

def m24(i)
    a = source "a"
    x = s24(a)
    sink x[0] # $ hasValueFlow=a
    sink x[1]
    sink x[i] # $ hasValueFlow=a
end

def m25(i)
    a = source "a"
    b = source "b"
    h = []
    h[0] = a
    h[1] = b
    sink s25(h) # $ hasValueFlow=a
end

def m26(i)
    a = source "a"
    x = s26(a)
    sink x[0] # $ hasValueFlow=a
    sink x[1]
    sink x[i] # $ SPURIOUS: hasValueFlow=a
end

def m27(i)
    a = source "a"
    b = source "b"
    c = source "c"
    d = source "d"

    h = []
    h[0] = a
    h[1] = b
    h[2] = c
    h[i] = d

    sink s27(h) # $ hasValueFlow=b hasValueFlow=c hasValueFlow=d
end

def m28(i)
    a = source "a"
    x = s28(a)
    sink x[0] # $ SPURIOUS: hasValueFlow=a
    sink x[1] # $ hasValueFlow=a
    sink x[2] # $ hasValueFlow=a
    sink x[i] # $ hasValueFlow=a
end

def m29(i)
    a = source "a"
    b = source "b"
    c = source "c"

    h = []
    h[0] = a
    h[1] = b
    h[2] = c
    h[i] = d

    sink s29(h) # $ hasValueFlow=b hasValueFlow=c
end

def m30(i)
    a = source "a"
    x = s30(a)
    sink x[0] # $ SPURIOUS: hasValueFlow=a
    sink x[1] # $ hasValueFlow=a
    sink x[2] # $ hasValueFlow=a
    sink x[i] # $ SPURIOUS: hasValueFlow=a
end

def m31(h, i)
    h[:foo] = source("a")
    h[:bar] = source("b")
    h[1] = source("c")
    h[i] = source("d")
    
    sink s31(h) # $ hasValueFlow=a hasValueFlow=d
end

def m32(h, i)
    h[:foo] = source("a")
    h["foo"] = source("b")
    h[:bar] = source("c")
    h[1] = source("d")
    h[i] = source("e")
    
    sink s32(h) # $ hasValueFlow=b $ hasValueFlow=e $ SPURIOUS: hasValueFlow=a
end

def m33(h, i)
    h[:foo] = source("a")
    h["foo"] = source("b")
    h[:bar] = source("c")
    h[1] = source("d")
    h[i] = source("e")
    h[nil] = source("f")
    h[true] = source("g")
    h[false] = source("h")
    
    sink s33(h) # $ hasValueFlow=e hasValueFlow=f hasValueFlow=g hasValueFlow=h
end

def m35(h, i)
    x = s35(source("a"))
    sink x[:foo] # $ hasValueFlow=a
    sink x[:bar]
    sink x[i] # $ hasValueFlow=a
end

def m36(h, i)
    x = s36(source("a"))
    sink x[:foo] # $ SPURIOUS: hasValueFlow=a
    sink x["foo"] # $ hasValueFlow=a
    sink x[:bar]
    sink x[i] # $ hasValueFlow=a
end

def m37(h, i)
    x = s37(source("a"))
    sink x[:foo]
    sink x[true] # $ hasValueFlow=a
    sink x[:bar]
    sink x[i] # $ hasValueFlow=a
end

def m38(h, i)
    h["foo"] = source("a")
    h[i] = source("b")
    
    sink s38(h) # $ hasValueFlow=a
end

def m39(i)
    x = s39(source("a"))

    sink x[:foo] # $ hasValueFlow=a
    sink x[i] # $ SPURIOUS: hasValueFlow=a
end

def m40
    x = A.new
    x.foo = source("a")
    x.bar = source("b")
    sink s40(x) # $ hasValueFlow=a
end

def m41
    x = s41(source("a"))
    sink x.foo # $ hasValueFlow=a
    sink x.bar
end

def m42(i, h)
    h[0] = source("a")
    h[i] = source("b")

    x = s42(h)

    sink x[0] # $ hasValueFlow=a hasValueFlow=b
    sink x[1] # $ hasValueFlow=b
    sink x[i] # $ hasValueFlow=a hasValueFlow=b
end

def m43(i, h)
    h[0] = source("a")
    h[i] = source("b")

    x = s43(h)

    sink x[0] # $ hasValueFlow=a
    sink x[1]
    sink x[i] # $ hasValueFlow=a
end

def m44(i, h)
    h[0] = source("a")
    h[1] = source("b")
    h[i] = source("c")

    s44(h)
    
    sink h[0]
    sink h[1] # $ hasValueFlow=b
    sink h[i] # $ hasValueFlow=b
end

def m45(i, h)
    h[0] = source("a")
    h[1] = source("b")
    h[i] = source("c")

    sink h[0] # $ hasValueFlow=a hasValueFlow=c
    sink h[1] # $ hasValueFlow=b hasValueFlow=c
    sink h[i] # $ hasValueFlow=a hasValueFlow=b hasValueFlow=c

    s45(h)
    
    sink h[0] # $ hasValueFlow=c
    sink h[1] # $ hasValueFlow=b hasValueFlow=c
    sink h[i] # $ hasValueFlow=b hasValueFlow=c
end

def m46(i, h)
    h[0] = source("a")
    h[1] = source("b")
    h[i] = source("c")

    sink h[0] # $ hasValueFlow=a hasValueFlow=c
    sink h[1] # $ hasValueFlow=b hasValueFlow=c
    sink h[i] # $ hasValueFlow=a hasValueFlow=b hasValueFlow=c

    x = s46(h)
    
    sink x[0]
    sink x[1] # $ hasValueFlow=b
    sink x[i] # $ hasValueFlow=b
end

def m47(i, h)
    h[:foo] = source("a")
    h[:bar] = source("b")
    h[i] = source("c")
    
    sink h[:foo] # $ hasValueFlow=a hasValueFlow=c
    sink h[:bar] # $ hasValueFlow=b hasValueFlow=c
    
    x = s47(h)
    
    sink x[:foo]
    sink x[:bar] # $ hasValueFlow=b
end

def m48(i, h)
    h[:foo] = source("a")
    h[:bar] = source("b")
    h[i] = source("c")
    
    sink h[:foo] # $ hasValueFlow=a hasValueFlow=c
    sink h[:bar] # $ hasValueFlow=b hasValueFlow=c
    
    x = s48(h)
    
    sink x[:foo]
    sink x[:bar] # $ hasValueFlow=b
end

def m49(i, h)
    h[:foo] = source("a")
    h[:bar] = source("b")
    h[i] = source("c")
    
    sink h[:foo] # $ hasValueFlow=a hasValueFlow=c
    sink h[:bar] # $ hasValueFlow=b hasValueFlow=c
    
    x = s49(h)
    
    sink x[:foo] # $ hasValueFlow=c
    sink x[:bar] # $ hasValueFlow=b hasValueFlow=c
end

def m50(i, h)
    h[:foo] = source("a")
    h[:bar] = source("b")
    h[i] = source("c")
    
    sink h[:foo] # $ hasValueFlow=a hasValueFlow=c
    sink h[:bar] # $ hasValueFlow=b hasValueFlow=c
    
    s50(h)
    
    sink h[:foo]
    sink h[:bar] # $ hasValueFlow=b
end

def m51(i, h)
    h[:foo] = source("a")
    h[:bar] = source("b")
    h[i] = source("c")
    
    sink h[:foo] # $ hasValueFlow=a hasValueFlow=c
    sink h[:bar] # $ hasValueFlow=b hasValueFlow=c
    
    s51(h)
    
    sink h[:foo] # $ hasValueFlow=c
    sink h[:bar] # $ hasValueFlow=b hasValueFlow=c
end

def m52(i, h)
    h[:foo] = source("a")
    h[:bar] = source("b")
    h[i] = source("c")
    
    sink h[:foo] # $ hasValueFlow=a hasValueFlow=c
    sink h[:bar] # $ hasValueFlow=b hasValueFlow=c
    
    h.s52
    
    sink h[:foo]
    sink h[:bar] # $ hasValueFlow=b
end

def m53(i, h)
    h[:foo] = source("a")
    h[:bar] = source("b")
    h[i] = source("c")
    
    sink h[:foo] # $ hasValueFlow=a hasValueFlow=c
    sink h[:bar] # $ hasValueFlow=b hasValueFlow=c
    
    x = h.s53()
    
    sink x[:foo]
    sink x[:bar] # $ hasValueFlow=b

    sink(source("d").s53()) # $ hasValueFlow=d
end

def m54(i, h)
    h[:foo] = source("a")
    h[:bar] = source("b")
    h[i] = source("c")

    sink h[:foo] # $ hasValueFlow=a hasValueFlow=c
    sink h[:bar] # $ hasValueFlow=b hasValueFlow=c

    x = h.s54()

    sink x[:foo]
    sink x[:bar] # $ hasValueFlow=b

    sink(source("d").s54())
end
