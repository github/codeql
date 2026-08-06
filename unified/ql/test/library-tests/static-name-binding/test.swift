class B {} // name=top.B

class A {
    class B {
        class C {}
    }
}

let x1: B = nil;   // $ access=top.B
let x2: A.B = nil; // $ access=A access=A.B
let x3: A.B.C = nil; // $ access=A access=A.B access=A.B.C

class D {
    let x1: B = nil;   // $ access=top.B
    let x2: A.B = nil; // $ access=A access=A.B
    let x3: A.B.C = nil; // $ access=A access=A.B access=A.B.C

    func member() {
        let x1: B = nil;   // $ access=top.B
        let x2: A.B = nil; // $ access=A access=A.B
        let x3: A.B.C = nil; // $ access=A access=A.B access=A.B.C
    }
}

class E {
    class A {
        class B {
        }
    }

    let x1: A = nil; // $ access=E.A
    let x2: A.B = nil; // $ access=E.A access=E.A.B
}

class F {
    static let field = 1
    static let (a,b) = (1,2)

    static func foo() {
        F.field // $ access=F access=F.field
        F.a // $ access=F access=F.a
        F.b // $ access=F access=F.b
    }
}
