class A {
    class B {
        class C {}
    }
}

class ASub : A { // $ access=A
    let x1: B = nil; // $ access=A.B
    let x2: B.C = nil; // $ access=A.B access=A.B.C

    class BSub : B { // $ access=A.B
        let x3: B = nil; // $ access=A.B
        let x4: C = nil; // $ access=A.B.C SPURIOUS: access=Target3.C // spurious result from folder-based heuristic
    }

    class BSub2 : B { // $ access=A.B
        class C {} // shadow the inherited C
        let x5: C = nil; // $ access=ASub.BSub2.C
    }
}
