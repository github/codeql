class A {
    static func static_before() {
        print(staticVar) // $ access=staticVar
        B(); // $ access=A.B
        let b: B = nil // $ access=A.B
        let c: C = nil // $ access=A.C
    }
    func instance_before() {
        print(instanceVar) // $ access=instanceVar
        B(); // $ access=A.B
        let b: B = nil // $ access=A.B
        let c: C = nil // $ access=A.C
    }

    private static let staticVar = 123
    private let instanceVar = 456

    class B {} // name=A.B
    typealias C = B // $ access=A.B // name=A.C

    static func static_after() {
        print(staticVar) // $ access=staticVar
        B(); // $ access=A.B
        let b: B = nil // $ access=A.B
        let c: C = nil // $ access=A.C

    }
    func instance_after() {
        print(instanceVar) // $ access=instanceVar
        B(); // $ access=A.B
        let b: B = nil // $ access=A.B
        let c: C = nil // $ access=A.C
    }
}

class Base {} // name=top.Base

// Base types and type parameter bounds can't see members in the class body
class C : Base { // $ access=top.Base
    class Base {} // name=C.Base
}

class D<T : Base> { // $ access=top.Base
    class Base {} // name=D.Base
}

class E<T> where T : Base { // $ access=T access=top.Base
    class Base {} // name=E.Base
}

// Base types and type parameter bounds can see type parameters
class F<TypeParamF> :
    D<TypeParamF> { // $ access=D access=TypeParamF
}

class G<TypeParamG :
    D<TypeParamG>> { // $ access=D access=TypeParamG
}

class H<TypeParamH> where
    TypeParamH : Base { // $ access=TypeParamH access=top.Base
}

// Type parameter bounds can see other type parameters, even if declared later
class I<
    T1 : D<T2>, // $ access=D access=I.T2
    T2> { // name=I.T2
}

// Members can see type parameters.
class J<TypeParamI> {
    let x: TypeParamI; // $ access=TypeParamI
}

typealias Alias<TypeParamAlias> =
    D<TypeParamAlias>; // $ access=D access=TypeParamAlias

func foo<FooT>(x: FooT) // $ access=FooT
    -> D<FooT> { // $ access=D access=FooT
    let x: FooT = nil // $ access=FooT
    return D<FooT>() // $ access=D access=FooT
}
