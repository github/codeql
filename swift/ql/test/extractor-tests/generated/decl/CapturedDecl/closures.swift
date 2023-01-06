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

func logical() -> Bool {
  let f: ((Int) -> Int)? = { (x) in x + 1 }
  let x: Int? = 42
  return f != nil
      && (x != nil
          && f!(x!) == 43)
}

func asyncTest() {
  func withCallback(_ callback: @escaping (Int) async -> Int) {
    func wrapper(_ x: Int) async -> Int {
      return await callback(x + 1)
    }
    Task {
      print(await wrapper(42))
    }
  }
  withCallback { x in
    x + 1
  }
}
