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
