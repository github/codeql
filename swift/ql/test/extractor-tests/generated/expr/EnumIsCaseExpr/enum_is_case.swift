// EnumIsCaseExpr despite its generic nature is actually only generated when an `is` expression passes through an
// intrinsic Optional check, or an array, dictionary or set downcast

Optional.some(42) is Int
Optional.some(Optional.some(42)) is Int
42 is Int?
42 is Int??

[Optional.some(42)] is [Int]
[42] is [Int?]

class X : Hashable {
    static func == (lhs: X, rhs: X) -> Bool { return true }
    func hash(into hasher: inout Hasher) {}
}

class Y: X {}

Optional.some(Y()) is X

[X()] is [Y]
["x": X()] is [String: Y]
["x": X()] is [String: Y]
Set<X>() is Set<Y>
