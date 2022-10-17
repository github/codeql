func f(_: UnsafePointer<CChar>) {}
f("Hello")  // StringToPointerExpr

let a : Int? = 42  // InjectIntoOptionalExpr
let b : any Equatable = 42  // ErasureExpr
