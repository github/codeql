// Arbitrary expressions may appear in pattern context
switch x {
case y, y + 1, -y, y...z, "foo", 4, foo().bar, .baz, [42], ["a": 1], try y, y!, y is T, await y, "interpolate \(y)":
    print("expr")
case true ? y : z:
    print("ternary is also valid")
default:
    break
}
