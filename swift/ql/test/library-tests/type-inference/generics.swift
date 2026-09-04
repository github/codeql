// --- Generic functions ---

// identity
func identity<T>(_ x: T) -> T {
  return x // $ type=x:T
}

// makePair
func makePair<A, B>(_ a: A, _ b: B) -> (A, B) {
  return (a, b) // $ type=a:A
}

func testGenericFunctions() {
  let i = identity(42) // $ type=i:Int target=identity
  let s = identity("hello") // $ type=s:String target=identity
  let p = makePair(1, "two") // $ target=makePair
}

// --- Generic structs ---

struct Pair<A, B> {
  var first : A
  var second : B

  // Pair.init
  init(first: A, second: B) {
    self.first = first // $ type=first:A
    self.second = second // $ type=second:B
  }

  // Pair.getFirst
  func getFirst() -> A {
    return first // $ type=.first:A
  }

  // Pair.getSecond
  func getSecond() -> B {
    return second // $ type=.second:B
  }
}

func testGenericStruct() {
  let p = Pair(first: 1, second: "x") // $ target=Pair.init type=p@Pair<A>:Int type=p@Pair<B>:String
  let f = p.getFirst() // $ type=f:Int target=Pair.getFirst
  let sc = p.getSecond() // $ type=sc:String target=Pair.getSecond
}

// --- Enums with associated values ---

enum Result<T> {
  // Result.success
  case success(T)
  // Result.failure
  case failure(String)

  // Result.getValue
  func getValue() -> T? {
    switch self {
    case .success(let v): // $ target=Result.success
      return v // $ type=v:T
    case .failure: // $ target=Result.failure
      return nil
    }
  }
}

func testEnum() {
  let r = Result.success(42) // $ type=r@Result<T>:Int target=Result.success
  let v = r.getValue() // $ target=Result.getValue

  let r2 : Result<Int> = .success(42) // $ type=r2@Result<T>:Int target=Result.success
  let v2 = r2.getValue() // $ target=Result.getValue
}

// --- Closures and type inference ---

// applyTransform
func applyTransform<T, U>(_ value: T, _ transform: (T) -> U) -> U {
  return transform(value)
}

func testClosures() {
  let result = applyTransform(5, { x in x * 2 }) // $ target=applyTransform type=result:Int
  let strings = applyTransform(10, { x in String(x) }) // $ target=applyTransform type=strings:String
}

// --- Generic class with constraints ---

protocol MyProtocol {
  associatedtype MyType

  // MyProtocol.foo
  func foo() -> Self

  // MyProtocol.bar
  func bar() -> MyType
}

class Wrapper<T: MyProtocol> {
  var inner : T

  // Wrapper.init
  init(_ inner: T) {
    self.inner = inner // $ type=inner:T
  }

  // Wrapper.get
  func get() -> T {
    return inner // $ type=.inner:T
  }

  // Wrapper.callFoo
  func callFoo() -> T {
    let x = inner.foo(); // $ type=x:T target=MyProtocol.foo
    return x
  }

  // Wrapper.callBar
  func callBar() -> T.MyType {
    let x = inner.bar(); // $ type=x:MyType target=MyProtocol.bar
    return x
  }
}

extension Int : MyProtocol {
  typealias MyType = String
  
  // Int.foo
  func foo() -> Int {
    return self * 2 // $ type=self:Int
  }

  // Int.bar
  func bar() -> String {
    return "number"
  }
}

func testConstrainedGeneric() {
  let w = Wrapper(42) // $ type=w@Wrapper<T>:Int target=Wrapper.init
  let v = w.get() // $ type=v:Int target=Wrapper.get
  let z = w.callFoo() // $ type=z:Int target=Wrapper.callFoo
}
