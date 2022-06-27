// EnumIsCaseExpr despite its generic nature is actually only generated when an `is` expression passes through an
// intrinsic Optional check

Optional.some(42) is Int
Optional.some(Optional.some(42)) is Int
42 is Int?
42 is Int??

[Optional.some(42)] is [Int]
[42] is [Int?]

class X {}
class Y: X {}
Optional.some(Y()) is X
