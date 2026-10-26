protocol Foo {
    associatedtype Bar
    associatedtype Baz: Equatable

    var x: Bar? { get }
    var y: Baz { get set }
}

class FooImpl: Foo {
    var x: Int?
    var y: [Int] = []
}
