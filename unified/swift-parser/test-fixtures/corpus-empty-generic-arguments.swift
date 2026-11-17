let spaced = G< >.self
let adjacent = G<>()
let nested = Box<G<>>.self
let typed: G<>
let optional = Either<Int, Double>??.none
let nestedOptional = Outer.E<Inner>.F<Element>???.none
