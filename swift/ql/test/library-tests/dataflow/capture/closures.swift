func sink<T>(_ value: T) { print("sink:", value) }
func source<T>(_ label: String, _ value: T) -> T { return value }
func taint<T>(_ label: String, _ value: T) -> T { return value }

func hello() -> String {
  let value = "Hello world!"
  return source("hello", value)
}

func captureList() {
  let y: Int = source("captureList", 123);
  { [x = hello()] () in
     sink(x) // $ MISSING: hasValueFlow=hello
     sink(y) // $ MISSING: hasValueFlow=captureList
  }()
}

func withoutCaptureList() {
  let y: Int = source("withoutCaptureList", 124);
  { [] () in
     sink(y) // $ hasValueFlow=withoutCaptureList
  }()
}

func setAndCallEscape() {
  let x = source("setAndCallEscape", 0)

  let escape = {
    sink(x) // $ hasValueFlow=setAndCallEscape
    return x + 1
  }

  sink(escape()) // $ hasTaintFlow=setAndCallEscape
}

var escape: (() -> Int)? = nil

func setEscape() {
  let x = source("setEscape", 0)
  escape = {
    sink(x) // $ MISSING: hasValueFlow=setEscape
    return x + 1
  }
}

func callEscape() {
  setEscape()
  sink(escape?()) // $ MISSING: hasTaintFlow=setEscape
}

func logical() -> Bool {
  let f: ((Int) -> Int)? = { x in
    sink(x) // $ hasValueFlow=logical
    return x + 1
  }

  let x: Int? = source("logical", 42)
  return f != nil
      && (x != nil
          && f!(x!) == 43)
}

func asyncTest() {
  func withCallback(_ callback: @escaping (Int) async -> Int) {
    @Sendable
    func wrapper(_ x: Int) async -> Int {
      return await callback(x + 1) // $ MISSING: hasValueFlow=asyncTest
    }
    Task {
      print("asyncTest():", await wrapper(source("asyncTest", 40)))
    }
  }
  withCallback { x in
    x + 1 // $ MISSING: hasTaintFlow=asyncTest
  }
}

func foo() {
  var x = 1
  let f = { y in x += y }
  x = source("foo", 41)
  let r = { x }
  sink(r()) // $ hasValueFlow=foo
  f(1)
  sink(r()) // $ hasValueFlow=foo
}

func sharedCapture() {
  let (incrX, getX) = {
    var x = source("sharedCapture", 0)
    return ({ x += 1 }, { x })
  }()

  let doubleIncrX = {
    incrX()
    incrX()
  }

  sink(getX()) // $ MISSING: hasValueFlow=sharedCapture
  doubleIncrX()
  sink(getX()) // $ MISSING: hasTaintFlow=sharedCapture
}

func sharedCaptureMultipleWriters() {
  var x = 123

  let callSink1 = { sink(x) } // $ MISSING: hasValueFlow=setter1
  let callSink2 = { sink(x) } // $ MISSING: hasValueFlow=setter2

  let makeSetter = { y in
    let setter = { x = y }
    return setter
  }

  let setter1 = makeSetter(source("setter1", 1))
  let setter2 = makeSetter(source("setter2", 2))

  setter1()
  callSink1()

  setter2()
  callSink2()
}

func taintCollections(array: inout Array<Int>) {
  array[0] = source("array", 0)
  sink(array) // $ hasTaintFlow=array
  sink(array[0]) // $ hasValueFlow=array
  array.withContiguousStorageIfAvailable({
    buffer in
    sink(array) // $ hasTaintFlow=array
    sink(array[0]) // $ hasValueFlow=array
  })
}

func simplestTest() {
  let x = source("simplestTest", 0)
  sink(x) // $ hasValueFlow=simplestTest
}

func sideEffects() {
  var x = 0
  var f = { () in x = source("sideEffects", 1) }
  f()
  sink(x) // $ hasValueFlow=sideEffects
}

class S {
  var bf1 = 0
  var bf2 = 0
  func captureOther() {
    var other = S()
    var f = { x in
      other.bf1 = x;
    };

    // no flow
    sink(bf1);
    sink(other.bf1);
    sink(other.bf2);

    f(source("captureOther", 2));

    sink(other.bf1); // $ hasValueFlow=captureOther
    sink(other.bf2);
  }

  func captureThis() {
    var f = { [self] x in
      self.bf1 = x;
      bf2 = x;
    };

    // no flow
    sink(bf1);
    sink(self.bf2);

    f(source("captureThis", 2));

    sink(bf1); // $ MISSING: hasValueFlow=captureThis
    sink(self.bf2); // $ MISSING: hasValueFlow=captureThis
  }
}

func multi() {
  var x = 0
  var y = source("multi", 1)
  var f = { () in x = y }
  f()
  sink(x) // $ hasValueFlow=multi
}
