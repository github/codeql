func hello() -> String {
  return "Hello world!"
}

func captureList() {
  let y = 123
  { [x = hello()] () in
     print(x)
     print(y) }()
}

var escape: (() -> ())? = nil

func setEscape() {
  var x = 0
  escape = {
    x += 1
    print(x)
  }
}

func callEscape() {
  setEscape()
  escape?()
}

func logical() -> Bool {
  let f: ((Int) -> Int)? = { x in x + 1 }
  let x: Int? = 42
  return f != nil
      && (x != nil
          && f!(x!) == 43)
}

func asyncTest() {
  func withCallback(_ callback: @escaping (Int) async -> Int) {
    @Sendable
    func wrapper(_ x: Int) async -> Int {
      return await callback(x + 1)
    }
    Task {
      print("asyncTest():", await wrapper(40))
    }
  }
  withCallback { x in
    x + 1
  }
}

func foo() -> Int {
  var x = 1 // x is a non-escaping capture of f and r
  let f = { y in x += y }
  x += 40
  let r = { x }
  f(1)
  return r() // 42
}

func bar() -> () -> Int {
  var x = 1 // x is a non-escaping capture of f, escaping capture of r
  let f = { y in x += y }
  x += 40
  let r = { x }
  f(1)
  return r // constantly 42
}

var g: ((Int) -> Void)? = nil
func baz() -> () -> Int {
  var x = 1 // x is an escaping capture of g and r
  g = { y in x += y } // closure escapes!
  x += 40
  let r = { x }
  g!(1)
  return r
}

func quux() -> Int {
  var y = 0

  func f() -> () -> Void {
    var x = 5

    func a() {
      y = 10*y + x
      x -= 1
      if x > 0 {
        b()
      }
    }

    func b() {
      y = 10*y + 2*x
      x -= 1
      if x > 0 {
        a()
      }
    }

    return a
  }

  let a = f()
  a()
  return y // 58341
}

func sharedCapture() -> Int {
  let (incrX, getX) = {
    var x = 0
    return ({ x += 1 }, { x })
  }()

  let doubleIncrX = {
    incrX()
    incrX()
  }

  doubleIncrX()
  doubleIncrX()
  return getX() // 4
}

func sink(_ x: Int) { print("sink:", x) }
func source() -> Int { -1 }

func sharedCaptureMultipleWriters() {
  var x = 123

  let callSink = { sink(x) }

  let makeSetter = { y in
    let setter = { x = y }
    return setter
  }

  let goodSetter = makeSetter(42)
  let badSetter = makeSetter(source())

  goodSetter()
  callSink()

  badSetter()
  callSink()
}

func reentrant() -> Int {

  func f(_ x: Int) -> (Int) -> Int {
    if x == 0 {
      return { _ in x }
    }

    let next = g(x - 1)
    return { k in k*next(10*k) + x }
  }

  func g(_ x: Int) -> (Int) -> Int {
    if x == 0 {
      return { _ in x }
    }

    let next = f(x - 1)
    return { k in k*next(10*k) + 2*x }
  }

  let h = f(5)

  let y = h(10)

  return y // 10004003085
}

func main() {
  print("captureList():")
  captureList() // Hello world! 123

  print("callEscape():")
  callEscape() // 1

  print("logical():", logical()) // true

  print("asyncTest():")
  asyncTest() // 42

  print("foo():", foo()) // 42

  let a = bar()
  let b = baz()

  print("bar():", a(), a()) // 42 42

  print("baz():", b(), b()) // 42 42

  g!(1)
  print("g!(1):", b(), b()) // 43 43

  g!(1)
  print("g!(1):", b(), b()) // 44 44

  print("quux():", quux()) // 58341

  print("sharedCapture():", sharedCapture()) // 4

  print("sharedCaptureMultipleWriters():")
  sharedCaptureMultipleWriters() // 42, -1

  print("reentrant():", reentrant()) // 10004003085
}

main()
