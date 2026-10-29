struct S {}

class C {}

extension S {
    var x : Int { get { return 42 } }

    func foo() {}
}

extension C {
    var y : Int { get { return 404 } }

    func bar() {}
}

protocol P1 {
    func baz()
}

extension S : P1 {
    func baz() {}
}

protocol P2 {}

extension C : P1, P2 {
    func baz() {}
}
