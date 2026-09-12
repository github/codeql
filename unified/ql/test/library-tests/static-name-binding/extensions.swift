class A {
    func ownMethod() {
        ownMethod() // $ access=A.ownMethod
        extensionMethod1() // $ MISSING: access=A.extensionMethod1
        extensionMethod2() // $ MISSING: access=A.extensionMethod2
    }
}

extension A { // $ access=A
    func extensionMethod1() { // name=A.extensionMethod1
        ownMethod() // $ MISSING: access=A.ownMethod
        extensionMethod1() // $ MISSING: access=A.extensionMethod1
        extensionMethod2() // $ MISSING: access=A.extensionMethod2
    }
}

extension A { // $ access=A
    func extensionMethod2() { // name=A.extensionMethod2
        ownMethod() // $ MISSING: access=A.ownMethod
        extensionMethod1() // $ MISSING: access=A.extensionMethod1
        extensionMethod2() // $ MISSING: access=A.extensionMethod2
    }
}
