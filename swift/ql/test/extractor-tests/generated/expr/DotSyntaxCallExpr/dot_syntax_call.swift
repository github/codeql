class X {
  static func foo(_: Int, _:Int) {}
  class func bar() {}
  func baz(_: Int) {}

  init() {
    let f = baz
  }
}

X.foo(1, 2)
X.bar()
X().baz(42)

let f = X.bar
let g = X().baz
