struct A {
    var x: Int = 42
}

_ = \A.x

struct B {
    var a: A
}

_ = \B.a.x
