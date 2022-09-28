protocol P1 {
    associatedtype Associated
}

protocol P2 {
    associatedtype AssociatedWithProtocols : Equatable, P1
}

class S {}

protocol P3 {
    associatedtype AssociatedWithSuperclass : S
}

protocol P4 {
    associatedtype AssociatedWithSuperclassAndProtocols : S, Equatable, P1
}

class A<Impl1: P1, Impl2: P2, Impl3: P3, Impl4: P4> {
    func foo(_: Impl1.Associated,
             _: Impl2.AssociatedWithProtocols,
             _: Impl3.AssociatedWithSuperclass,
             _: Impl4.AssociatedWithSuperclassAndProtocols) {}
}
