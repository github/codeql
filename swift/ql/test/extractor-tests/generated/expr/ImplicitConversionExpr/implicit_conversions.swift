func f(_: UnsafePointer<CChar>) {}
f("Hello")  // StringToPointerExpr

let a : Int? = 42  // InjectIntoOptionalExpr
let b : any Equatable = 42  // ErasureExpr

@preconcurrency class A {
  @preconcurrency var b: (@Sendable () -> Void)?
}

func g(_ a: A) {
  a.b = {}
}

