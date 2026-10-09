class A {
    class B {
        class C {}
    }

    static func f() {}
}

class D: A {  // $ access=A
    static func f(x: Int) {}  // $ access=Int
}
class E: D.B {  // $ access=D access=A.B
    override init() {}
}

class F {
    private init() {}
}

class G: F {  // $ access=F
    public init() {}
}

class H: G {  // $ access=G
    public init(x: String) {}  // $ access=String
}

class I: H {}  // $ access=H

class J: I {  // $ access=I
    convenience init() {
        self.init(x: "")
    }
}

protocol P {
    init()
}

final class K: P {}  // $ access=P

struct S: P {}  // $ access=P

class L {
    init(x: Int) {}  // $ access=Int // name=L.init1

    init(x: Int, y: Int) {}  // $ access=Int // name=L.init2

    convenience init() { self.init(x: 0) }  // name=L.init_conv
}

class M: L {  // $ access=L
    override init(x: Int) { super.init(x: 0) }  // $ access=Int

    override init(x: Int, y: Int) { super.init(x: 0, y: 0) }  // $ access=Int
}

class N: L {  // $ access=L
    override init(x: Int) { super.init(x: 0) }  // $ access=Int

    convenience init  // name=N.init_conv
        (a: Int, b: Int, c: Int)  // $ access=Int
    {
        self.init(x: a + b + c)  // $ access=a access=b access=c
    }
}

class O: N {  // $ access=N
    override init(x: Int) {  // $ access=Int
        super.init(x: x)  // $ access=x
    }
}

// Members of base classes can be accessed through derived classes
func t1() {
    let x1: D = D()  // $ access=D
    let x2: D.B = D.B()  // $ access=D access=A.B
    let x3: D.B.C = D.B.C()  // $ access=D access=A.B access=A.B.C

    // The base class of 'E' is itself resolved through inheritance
    let x4: E = E()  // $ access=E
    let x5: E.C = E.C()  // $ access=E access=A.B.C

    let x6 = A.init()  // $ access=A access=A.init
    let x7 = D.init()  // $ access=D access=A.init

    let x8 = A.f()  // $ access=A access=A.f
    let x9 = D.f()  // $ access=D access=A.f access=D.f -- type inference should filter away the `D.f` target
    let x10 = D.f(x: 0)  // $ access=D access=A.f access=D.f -- type inference should filter away the `A.f` target

    let x11 = E.init()  // $ access=E access=E.init

    let x12 = G.init()  // $ access=G access=G.init

    let x13 = H.init(x: "String")  // $ access=H access=H.init

    let x14 = I.init(x: "String")  // $ access=I access=H.init

    let x15 = J.init()  // $ access=J access=J.init access=H.init -- type inference should filter away the `H.init` target

    let x16 = K.init()  // $ access=K access=K.init

    let x17 = S.init()  // $ access=S access=S.init

    let x18 = M.init(x: 0)  // $ access=M access=M.init access=L.init_conv -- type inference should filter away the `L.init_conv` target

    let x19 = M.init()  // $ access=M access=M.init access=L.init_conv -- type inference should filter away the `M.init` target

    let x20 = N.init(x: 0)  // $ access=N access=N.init access=N.init_conv access=L.init_conv -- type inference should filter away the `N.init_conv` and `L.init_conv` targets

    let x21 = O.init(x: 0)  // $ access=O access=O.init access=N.init_conv access=L.init_conv -- type inference should filter away the `N.init_conv` and `L.init_conv` targets

    let x22 = O.init(a: 1, b: 2, c: 3)  // $ access=O access=O.init access=N.init_conv access=L.init_conv -- type inference should filter away the `O.init` and `L.init_conv` targets
}
