let key = \Foo.bar ? 1 : 2
let comparison = \Foo.bar != other
let coalesced = (\Foo.bar) ?? other
let distinct = \Foo.bar
[0].foo()
let forward = zip(a, b).map(/) + foo(1, /)
let parentheses = (foo(/x)/)
let whitespace = foo(/x / y)
prefix func /(value: Int) -> Int { value }
infix operator /
let regex = foo(/(x)/, /[)]/)
let effects = [(Int) async throws -> Void, (Int) async throws(Error) -> Void]
switch value {
case 0:
    foo { a }
default:
    { b }()
}
