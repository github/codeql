class Foo {
    var field: Int

    init() {
        field = 10
    }
}

protocol Bar {}

class Generic<X, Y> {
    var x: X?
    var y: Y?
}

class Baz: Foo, Bar {
}
