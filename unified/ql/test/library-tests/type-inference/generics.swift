// --- Generic functions ---

func identity<T>(_ x: T) -> T {
  return x  // $ type=x:T
}

func makePair<A, B>(_ a: A, _ b: B) -> (A, B) {
  return (a, b)  // $ type=a:A
}

func testGenericFunctions() {
  let i = identity(42)  // $ type=i:Int target=identity
  let s = identity("hello")  // $ type=s:String target=identity
  let p = makePair(1, "two")  // $ target=makePair
}

// --- Generic structs ---

struct Pair<A, B> {
  var first: A
  var second: B

  init(first: A, second: B) {
    self.first = first  // $ type=first:A field=Pair.first
    self.second = second  // $ type=second:B field=Pair.second
  }

  func getFirst() -> A {
    return first  // $ type=first:A field=Pair.first
  }

  func getSecond() -> B {
    return second  // $ type=second:B field=Pair.second
  }
}

func testGenericStruct() {
  let p = Pair(first: 1, second: "x")  // $ target=Pair.init type=p@Pair<A>:Int type=p@Pair<B>:String
  let f = p.getFirst()  // $ type=f:Int target=Pair.getFirst
  let sc = p.getSecond()  // $ type=sc:String target=Pair.getSecond
}

// --- Enums with associated values ---

enum Result<T> {
  case success(T)
  case failure(String)

  func getValue() -> T? {
    switch self {
    case .success(let v):  // $ MISSING: target=Result.success
      return v  // $ MISSING: type=v:T
    case .failure:  // $ MISSING: target=Result.failure
      return nil
    }
  }
}

func testEnum() {
  let r = Result.success(42)  // $ type=r@Result<T>:Int target=Result.success
  let v = r.getValue()  // $ target=Result.getValue

  let r2: Result<Int> = .success(42)  // $ type=r2@Result<T>:Int $ MISSING: target=Result.success
  let v2 = r2.getValue()  // $ target=Result.getValue
}

// --- Closures and type inference ---

func applyTransform<T, U>(_ value: T, _ transform: (T) -> U) -> U {
  let result = transform(value)  // $ type=result:U target=Function.invoke
  return result
}

func testClosures() {
  let result = applyTransform(5, { x in x * 2 })  // $ target=applyTransform type=result:Int
  let strings = applyTransform(  // $ type=strings:String
    10,
    {
      x in String(x)  // $ type=x:Int target=String.init
    })  // $ target=applyTransform
}

// --- Generic class with constraints ---

protocol MyProtocol {
  associatedtype MyType

  func foo() -> Self

  func bar() -> MyType
}

class Wrapper<T: MyProtocol> {
  var inner: T

  init(_ inner: T) {
    self.inner = inner  // $ type=inner:T field=Wrapper.inner
  }

  func get() -> T {
    return inner  // $ type=inner:T field=Wrapper.inner
  }

  func callFoo() -> T {
    let x = inner.foo()  // $ field=Wrapper.inner $ MISSING:  type=x:T target=MyProtocol.foo
    return x
  }

  func callBar() -> T.MyType {
    let x = inner.bar()  // $ field=Wrapper.inner $ MISSING: type=x:MyType target=MyProtocol.bar
    return x
  }
}

extension Int: MyProtocol {
  typealias MyType = String

  func foo() -> Int {
    return self * 2  // $ type=self:Int
  }

  func bar() -> String {
    return "number"
  }
}

func testConstrainedGeneric() {
  let w = Wrapper(42)  // $ type=w@Wrapper<T>:Int target=Wrapper.init
  let v = w.get()  // $ type=v:Int target=Wrapper.get
  let z = w.callFoo()  // $ type=z:Int target=Wrapper.callFoo
  let x = w.callBar()  // $ target=Wrapper.callBar $ MISSING: type=x:String
}

// --- Generics and inheritance ---

class Base<T1, T2> {
  var value1: T1
  var value2: T2

  init(_ v1: T1, _ v2: T2) {
    self.value1 = v1  // $ type=v1:T1 field=Base.value1
    self.value2 = v2  // $ type=v2:T2 field=Base.value2
  }

  func getValue1() -> T1 {
    return value1  // $ type=value1:T1 field=Base.value1
  }

  func getValue2() -> T2 {
    return value2  // $ type=value2:T2 field=Base.value2
  }
}

class Derived<T1, T2>: Base<T2, T1> {
  init(_ v1: T1, _ v2: T2) {
    super.init(v2, v1)  // $ type=v2:T2 type=v1:T1 target=Base.init
  }
}

class DerivedDerived<D>: Derived<D, Bool> {
  init(_ v: D) {
    super.init(v, true)  // $ type=v:D target=Derived.init
  }
}

func testDerived() {
  let d = Derived(1, "x")  // $ type=d@Derived<T1>:Int type=d@Derived<T2>:String target=Derived.init
  let v1 = d.getValue1()  // $ type=v1:String target=Base.getValue1
  let v2 = d.getValue2()  // $ type=v2:Int target=Base.getValue2

  let dd = DerivedDerived("hello")  // $ type=dd@DerivedDerived<D>:String target=DerivedDerived.init
  let vv1 = dd.getValue1()  // $ type=vv1:Bool target=Base.getValue1
  let vv2 = dd.getValue2()  // $ type=vv2:String target=Base.getValue2
}

// --- Generics and protocols ---

protocol MyProtocol2 {
  associatedtype MyType

  func baz() -> MyType
}

extension MyProtocol2 {
  func foo() -> Self {
    return self  // $ MISSING: type=self:Self
  }
}

class MyClass<T> {
  var value: T

  init(_ value: T) {
    self.value = value  // $ type=value:T field=MyClass.value
  }
}

extension MyClass: MyProtocol2 {
  typealias MyType = T

  func baz() -> T {
    return value  // $ field=MyClass.value $ MISSING: type=value:T
  }
}

func callFoo<T: MyProtocol2>(_ c: T) -> T {
  return c.foo()  // $ MISSING: target=MyProtocol2.foo
}

func callBaz<T: MyProtocol2>(_ c: T) -> T.MyType {
  return c.baz()  // $ MISSING: target=MyProtocol2.baz
}

func testProtocolExtension() {
  let c = MyClass(42)  // $ type=c@MyClass<T>:Int target=MyClass.init
  let s = c.foo()  // $ target=MyProtocol2.foo $ MISSING: type=s@MyClass<T>:Int
  let v = c.baz()  // $ target=MyClass.baz $ MISSING: type=v:Int
  let v2 = callBaz(c)  // $ target=callBaz $ MISSING: type=v2:Int
}

// --- Inherited associated types ---

protocol BaseAssociatedTypeProtocol {
  associatedtype Value

  func baseValue() -> Value
}

protocol SubAssociatedTypeProtocol: BaseAssociatedTypeProtocol {
  func subValue() -> Value
}

struct StringAssociatedType: SubAssociatedTypeProtocol {
  typealias Value = String

  func baseValue() -> String {
    return "base"
  }

  func subValue() -> String {
    return "sub"
  }
}

func getInheritedAssociatedType<T: SubAssociatedTypeProtocol>(_ value: T) -> T.Value {
  return value.subValue()  // $ MISSING: target=SubAssociatedTypeProtocol.subValue
}

func testInheritedAssociatedType() {
  let value = getInheritedAssociatedType(StringAssociatedType())  // $ target=getInheritedAssociatedType $ MISSING: type=value:String
}

// --- Primary associated types ---

protocol PrimaryAssociatedTypeProtocol<Element> {
  associatedtype Element

  func element() -> Element
}

struct IntPrimaryAssociatedType: PrimaryAssociatedTypeProtocol {
  typealias Element = Int

  func element() -> Int {
    return 42
  }
}

func getPrimaryAssociatedType(_ value: some PrimaryAssociatedTypeProtocol<Int>) -> Int {
  return value.element()  // $ MISSING: target=PrimaryAssociatedTypeProtocol.element
}

func testPrimaryAssociatedType() {
  let value = getPrimaryAssociatedType(IntPrimaryAssociatedType())  // $ type=value:Int target=getPrimaryAssociatedType
}
