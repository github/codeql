class A {
    class B {
        class C {}
    }
}

class D: A {} // $ access=A
class E: D.B {} // $ access=D access=A.B

// Members of base classes can be accessed through derived classes
func t1() {
    let x1: D = nil; // $ access=D
    let x2: D.B = nil; // $ access=D access=A.B
    let x3: D.B.C = nil; // $ access=D access=A.B access=A.B.C

    // The base class of 'E' is itself resolved through inheritance
    let x4: E = nil; // $ access=E
    let x5: E.C = nil; // $ access=E access=A.B.C
}
