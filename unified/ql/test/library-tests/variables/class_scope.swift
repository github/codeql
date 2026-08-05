class A {
    static func static_before() {
        print(staticVar) // $ MISSING: access=staticVar
        B(); // $ MISSING: access=A.B
        let b: B = nil // $ MISSING: access=A.B
        let c: C = nil // $ MISSING: access=A.C
    }
    func instance_before() {
        print(instanceVar) // $ MISSING: access=instanceVar
        B(); // $ MISSING: access=A.B
        let b: B = nil // $ MISSING: access=A.B
        let c: C = nil // $ MISSING: access=A.C
    }

    private static let staticVar = 123
    private let instanceVar = 456

    class B {} // name=A.B
    typealias C = B // $ MISSING: access=A.B // name=A.C

    static func static_after() {
        print(staticVar) // $ MISSING: access=staticVar
        B(); // $ MISSING: access=A.B
        let b: B = nil // $ MISSING: access=A.B
        let c: C = nil // $ MISSING: access=A.C

    }
    func instance_after() {
        print(instanceVar) // $ MISSING: access=instanceVar
        B(); // $ MISSING: access=A.B
        let b: B = nil // $ MISSING: access=A.B
        let c: C = nil // $ MISSING: access=A.C
    }
}

class Base {} // name=top.Base

// Base types and type parameter bounds can't see members in the class body
class C : Base { // $ MISSING: access=top.Base
    class Base {} // name=C.Base
}

class D<T : Base> { // $ MISSING: access=top.Base
    class Base {} // name=D.Base
}

class E<T> where T : Base { // $ MISSING: access=T access=top.Base
    class Base {} // name=E.Base
}

// Base types and type parameter bounds can see type parameters
class F<TypeParamF> :
    D<TypeParamF> { // $ MISSING: access=D access=TypeParamF
}

class G<TypeParamG :
    D<TypeParamG>> { // $ MISSING: access=D access=TypeParamG
}

class H<TypeParamH> where
    TypeParamH : Base { // $ MISSING: access=TypeParamH access=top.Base
}

// Type parameter bounds can see other type parameters, even if declared later
class I<
    T1 : D<T2>, // $ MISSING: access=D access=I.T2
    T2> { // name=I.T2
}

// Members can see type parameters.
class J<TypeParamI> {
    let x: TypeParamI; // $ MISSING: access=TypeParamI
}
