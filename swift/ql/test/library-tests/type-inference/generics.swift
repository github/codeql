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

// --- Generics and inheritance ---

class Base<T1, T2> {
  var value1 : T1
  var value2 : T2

  // Base.init
  init(_ v1: T1, _ v2: T2) {
    self.value1 = v1 // $ type=.value1:T1
    self.value2 = v2 // $ type=.value2:T2
  }

  // Base.getValue1
  func getValue1() -> T1 {
    return value1 // $ type=.value1:T1
  }

  // Base.getValue2
  func getValue2() -> T2 {
    return value2 // $ type=.value2:T2
  }
}

class Derived<T1, T2> : Base<T2, T1> {
  // Derived.init
  init(_ v1: T1, _ v2: T2) {
    super.init(v2, v1) // $ type=v2:T2 type=v1:T1 target=Base.init
  }
}

class DerivedDerived<D> : Derived<D, Bool> {
  // DerivedDerived.init
  init(_ v: D) {
    super.init(v, true) // $ type=v:D target=Derived.init
  }
}

func testDerived() {
  let d = Derived(1, "x") // $ type=d@Derived<T1>:Int type=d@Derived<T2>:String target=Derived.init
  let v1 = d.getValue1() // $ type=v1:String target=Base.getValue1
  let v2 = d.getValue2() // $ type=v2:Int target=Base.getValue2

  let dd = DerivedDerived("hello") // $ type=dd@DerivedDerived<D>:String target=DerivedDerived.init
  let vv1 = dd.getValue1() // $ type=vv1:Bool target=Base.getValue1
  let vv2 = dd.getValue2() // $ type=vv2:String target=Base.getValue2
}

// --- Generics and protocols ---

protocol MyProtocol2 {
  associatedtype MyType

  // MyProtocol2.baz
  func baz() -> MyType
}

extension MyProtocol2 {
  // MyProtocol2.foo
  func foo() -> Self {
    return self // $ type=self:Self
  }
}

class MyClass<T> {
  var value : T

  // MyClass.init
  init(_ value: T) {
    self.value = value // $ type=value:T
  }
}

extension MyClass : MyProtocol2 {
  typealias MyType = T

  // MyClass.baz
  func baz() -> T {
    return value // $ type=.value:T
  }
}

// callFoo
func callFoo<T : MyProtocol2>(_ c: T) -> T {
  return c.foo() // $ target=MyProtocol2.foo
}

// callBaz
func callBaz<T : MyProtocol2>(_ c: T) -> T.MyType {
  return c.baz() // $ target=MyProtocol2.baz
}

func testProtocolExtension() {
  let c = MyClass(42) // $ type=c@MyClass<T>:Int target=MyClass.init
  let s = c.foo() // $ type=s@MyClass<T>:Int target=MyProtocol2.foo
  let v = c.baz() // $ type=v:Int target=MyClass.baz
  let v2 = callBaz(c) // $ type=v2:Int target=callBaz
}
