let forward = a |> b + c
let defaultGroup = a <~ b
infix operator |>: Pipeline
infix operator <~
precedencegroup Pipeline {
    associativity: right
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}
let right = a |> b |> c
let mixed = a + b |> c * d
let unordered = a <~ b + c
let repeatedDefault = a <~ b <~ c
let comparisons = a < b < c
value &+= 1
value &-= 2
value &*= 3
value &<<= 4
value &>>= 5
let unknownCast = a <+> b as? Int
let simd = a .== b
infix operator <=>: DefaultPrecedence
let explicitDefault = a <=> b + c
#if DEBUG
infix operator <!!>: AdditionPrecedence
#endif
let conditionalOperator = a <!!> b
