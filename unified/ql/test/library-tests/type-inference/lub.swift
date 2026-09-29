class A {
  public init() {}
}

class B: A {
  public override init() {}
}

class C: A {}

func foo() {
  let b = B()  // $ type=b:B target=B.init
  let c = C()  // $ MISSING: type=c:C target=C.init
  let x = 2 > 3 ? b : c  // $ MISSING: type=x:A
}
