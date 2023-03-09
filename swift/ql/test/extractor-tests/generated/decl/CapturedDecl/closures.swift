func bar() -> String {
  return "Hello world!"
}

func foo() {
  let y = 123
  { [x = bar()] () in
     print(x)
     print(y) }()
}

var escape: (() -> ())? = nil

func baz() {
  var x = 0
  func quux() {
    x += 1
    print(x)
  }
  escape = quux
}

func callEscape() {
  baz()
  escape?()
}
