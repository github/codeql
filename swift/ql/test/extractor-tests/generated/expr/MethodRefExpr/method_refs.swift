class X {
  func bar(_: Int) {}

  init() {
    let f = bar
    bar(0)
  }
}

let x = X()
x.bar(42)

let f = x.bar
