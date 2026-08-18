class Base {
    class Nested {}
    static let member = 1
}

class Derived : Base {} // $ definition=Base

func test() {
    let local = 1 // name=local1
    local // $ definition=local1
    let local = 2 // name=local2
    local // $ definition=local2
    Derived.member // $ definition=Derived definition=Base.member
    let _: Derived.Nested? // $ definition=Derived definition=Base.Nested
}

typealias Alias = Derived // $ definition=Derived
let _: Alias.Nested? // $ definition=Alias definition=Base.Nested
