class A {
    func ownMethod() {
        ownMethod() // $ access=A.ownMethod
        extensionMethod1() // $ access=A.extensionMethod1
        extensionMethod2() // $ access=A.extensionMethod2
    }
}

extension A { // $ access=A
    func extensionMethod1() { // name=A.extensionMethod1
        ownMethod() // $ access=A.ownMethod
        extensionMethod1() // $ access=A.extensionMethod1
        extensionMethod2() // $ access=A.extensionMethod2
    }
}

extension A { // $ access=A
    func extensionMethod2() { // name=A.extensionMethod2
        ownMethod() // $ access=A.ownMethod
        extensionMethod1() // $ access=A.extensionMethod1
        extensionMethod2() // $ access=A.extensionMethod2
    }
}
