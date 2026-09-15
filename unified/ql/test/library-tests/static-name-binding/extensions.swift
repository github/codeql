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

class B {
}

extension B { // $ access=B
    class C { // name=B.C
        class D {} // name=B.C.D
    }
}
extension B { // $ access=B
    class Nested : C { // $ access=B.C
        let x : D // $ access=B.C.D
    }
}

// Protocol conformance through extension
protocol Base {
    func baseMethod();
    func baseMethodNoImpl();
    func baseMethodDefaultImpl();
}
extension Base { // $ access=Base
    func baseMethodExt() {} // name=BaseImpl.baseMethodExt
    func baseMethodDefaultImpl() {} // name=BaseImpl.baseMethodDefaultImpl
}
class X {
    func xMethod() {
        baseMethod() // $ access=X.baseMethod
        baseMethodNoImpl() // $ access=Base.baseMethodNoImpl // with no visible implementation, just resolve to the signature
        baseMethodExt() // $ access=BaseImpl.baseMethodExt

        // Static name binding may find multiple targets. Type inference should disambiguate.
        baseMethodDefaultImpl() // $ access=Base.baseMethodDefaultImpl access=BaseImpl.baseMethodDefaultImpl
    }
}

extension X : Base { // $ access=X access=Base
    func baseMethod() {} // name=X.baseMethod
}

class Y {
    func yMethod() {
        baseMethod() // $ access=Y.baseMethod
        baseMethodDefaultImpl() // $ access=Y.baseMethodDefaultImpl
    }
}
extension Y : Base { // $ access=Y access=Base
    func baseMethod() {} // name=Y.baseMethod
    func baseMethodDefaultImpl() {} // name=Y.baseMethodDefaultImpl
}

// Type parameters of the extended type should be in scope in the extension.
class GenericExtensionTarget<ExtensionTypeParameter> {}
extension GenericExtensionTarget { // $ access=GenericExtensionTarget
    func useTypeParameter(_: ExtensionTypeParameter) {} // $ MISSING: access=ExtensionTypeParameter
}
