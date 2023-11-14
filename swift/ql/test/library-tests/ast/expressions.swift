let a = 15
let b = 15.15
let b1 = true
let b2 = false
let m = #file
let s = "hello world"
let s1 = "hello \(a)"
let n: Int? = nil

enum AnError: Error {
  case failed
}

func failure(_ x: Int) throws {
  guard x != 0 else {
    throw AnError.failed
  }
}

try! failure(11)
try? failure(11)

class Klass {
  init() {}
}

let klass = Klass()

let d = ["1" : "2"]
_ = 15
_ = 15 is Int
_ = 15 as Double
_ = 15 as? Double
_ = 15 as! Double
print(d["1"])

func closured(closure: (Int, Int) -> Int) {
  closure(5, 7)
}

closured { (x: Int, y: Int) -> Int in
    return x + y
}
closured { x, y in
    return x + y
}
closured { return $0 + $1 }
closured { $0 + $1 }

struct S {
  let x: Int
}

_ = \S.x

func unsafeFunction(pointer: UnsafePointer<Int>) {
}
var myNumber = 1234
unsafeFunction(pointer: &myNumber)
withUnsafePointer(to: myNumber) { unsafeFunction(pointer: $0) }

class FailingToInit {
  init?(x: Int) {
    if x < 0 {
      return nil
    }
  }
}

class Base {
  let xx: Int
  init(x: Int) {
    xx = x
  }
}

class Derived: Base {
  init() {
    super.init(x: 22)
  }
}

let derived = Derived()
_ = derived.xx

var opt: Int?
opt!
d["a"]!

class ToPtr {}

let opaque = Unmanaged.passRetained(ToPtr()).toOpaque()
Unmanaged<ToPtr>.fromOpaque(opaque)

struct HasProperty {
  var settableField: Int {
    set { }
    get {
      return 0
    }
  }

  // A field can be marked as read-only by dirctly implementing
  // the getter between the braces.
  var readOnlyField1: Int {
    return 0
  }

  // Or by adding an access declaration
  var readOnlyField2: Int {
    get {
      return 0
    }
  }

  var normalField : Int

  subscript(x: Int) -> Int {
    get {
      return 0
    }
    set { }
  }

  subscript(x: Int, y : Int) -> Int {
    return 0
  }
}

func testProperties(hp : inout HasProperty) -> Int {
  hp.settableField = 42
  var x = hp.settableField
  var y = hp.readOnlyField1
  var z = hp.readOnlyField2
  hp.normalField = 99
  var w = hp.normalField
  hp[1] = 2
  return hp[3, 4]
}

struct B {
  var x : Int
}

struct A {
  var b : B
  var bs : [B]
  var mayB : B?
}

func test(a : A, keyPathInt : WritableKeyPath<A, Int>, keyPathB : WritableKeyPath<A, B>) {
  var apply_keyPathInt = a[keyPath: keyPathInt]
  var apply_keyPathB = a[keyPath: keyPathB]
  var nested_apply = a[keyPath: keyPathB][keyPath: \B.x]
}

func bitwise() {
  _ = ~1
  _ = 1 & 2
  _ = 1 | 2
  _ = 1 ^ 2
  _ = 1 << 0
  _ = 1 >> 0
}

struct Bar {
  var value : Int
  var opt : Int?
}

struct Foo {
  var value : Int
  var opt : Bar?
}

let prop = \Foo.value
let arrElement = \[Int][0]
let dictElement = \[String : Int]["a"]
let optForce = \Optional<Int>.self!
let optChain = \Foo.opt?.opt
let optChainWrap = \Foo.opt?.value
let slf = \Int.self
let tupleElement = \(Int, Int).0

func makeTuple<each T>(_ t: repeat each T) -> (repeat each T) {
  return (repeat each t)
}

let _ = makeTuple("A", 2)
