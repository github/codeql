class X {
  static func foo(_: Int, _:Int) {}
  class func bar() {}
  func baz(_: Int) {}

  init() {
    let f = baz
  }
}

actor Y {
  static func foo(_: Int, _:Int) {}
  func baz(_: Int) {}

  init() {
    let f = baz
  }
}

@MainActor
class Z {
  static func foo(_: Int, _:Int) {}
  nonisolated class func bar() {}
  func baz(_: Int) {}

  init() {
    let f = baz
  }
}

do {
  X.foo(1, 2)
  X.bar()
  X().baz(42)

  let f = X.bar
  let g = X().baz
}

Task {
  Y.foo(1, 2)
  await Y().baz(42)

  let f = Y.foo
}

Task {
  await Z.foo(1, 2)
  await Z.bar()
  await Z().baz(42)

  let f = Z.bar
  let g = (await Z()).baz
}
