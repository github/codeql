var topLevelDecl : Int = 0
0
topLevelDecl + 1

func returnZero() -> Int { return 0 }

returnZero()
Double(topLevelDecl)

enum MyError: Error {
    case error1, error2
    case error3(withParam: Int)
}

func isZero(x : Int) -> Bool { return x == 0 }

func mightThrow(x : Int) throws -> Void {
  guard x >= 0 else {
    throw MyError.error1
  }
  guard x <= 0 else {
    throw MyError.error3(withParam: x + 1)
  }
}

func tryCatch(x : Int) -> Int {
  do {
    try mightThrow(x: 0)
    print("Did not throw.")
    try! mightThrow(x: 0)
    print("Still did not throw.")

  } catch MyError.error1 , MyError.error2 where isZero(x: x) {
    return 0
  } catch MyError.error3(let withParam) {
    return withParam
  } catch is MyError {
    print("MyError")
  } catch {
    print("Unknown error \(error)")
  }
  return 0
}

func createClosure1(s : String) -> () -> String {
  return {
    return s + ""
  }
}

func createClosure2(x : Int) -> (_ : Int) -> Int {
  func f(y : Int) -> Int {
    return x + y
  }
  return f
}

func createClosure3(x : Int) -> (_ : Int) -> Int {
  return {
    (y) -> Int in x + y
  }
}

func callClosures() {
  var x1 = createClosure1(s: "")()
  var x2 = createClosure2(x: 0)(10)
  var x3 = createClosure3(x: 0)(10)
}

func maybeParseInt(s : String) -> Int? {
  var n : Int? = Int(s)
  return n
}

func forceAndBackToOptional() -> Int? {
  var nBang = maybeParseInt(s:"42")!
  var n = maybeParseInt(s:"42")
  return nBang + n!
}

func testInOut() -> Int {
  var temp = 10

  func add(a: inout Int) {
    a = a + 1
  }

  func addOptional(a: inout Int?) {
    a = nil
  }

  add(a:&temp)
  var tempOptional : Int? = 10
  addOptional(a:&tempOptional)
  return temp + tempOptional!
}

class C {
  let myInt: Int
  init(n: Int) {
    myInt = n
  }

  func getMyInt() -> Int {
    return myInt
  }
}

func testMemberRef(param : C, inoutParam : inout C, opt : C?) {
  let c = C(n: 42)
  let n1 = c.myInt
  let n2 = c.self.myInt
  let n3 = c.getMyInt()
  let n4 = c.self.getMyInt()

  let n5 = param.myInt
  let n6 = param.self.myInt
  let n7 = param.getMyInt()
  let n8 = param.self.getMyInt()

  let n9 = inoutParam.myInt
  let n10 = inoutParam.self.myInt
  let n11 = inoutParam.getMyInt()
  let n12 = inoutParam.self.getMyInt()

  let n13 = opt!.myInt
  let n14 = opt!.self.myInt
  let n15 = opt!.getMyInt()
  let n16 = opt!.self.getMyInt()

  let n17 = opt?.myInt
  let n18 = opt?.self.myInt
  let n19 = opt?.getMyInt()
  let n20 = opt?.self.getMyInt()
}

func patterns(x : Int) -> Bool {
  for _ in 0...10 {  }

  switch x {
    case 0, 1:
      return true
      return true
    case x where (x >= 2) && x < 5:
      return true
    default:
      return false
  }

  var obj : AnyObject = C(n: x)
  if obj is C {
    return true
  }

  let xOptional: Int? = x
  if case .some(let x) = xOptional {
    return x == 0
  } else {
    return false
  }
}

func testDefer(x : inout Int) {
  // Will print 1, 2, 3, 4
  defer {
    print("4")
  }

  defer {
    print("3")
  }

  defer {
    print("1")
     defer {
      print("2")
    }
  }
}

func m1(x : Int) {
  if x > 2 {
    print("x is greater than 2")
  }
  else if x <= 2 && x > 0 && !(x == 5) {
    print("x is 1")
  }
  else {
    print("I can't guess the number")
  }
}

func m2(b : Bool) -> Int {
  if b {
    return 0
  }
  return 1
}

func m3(x : inout Int) -> Int {
  if x < 0 {
    x = -x
    if x > 10 {
      x = x - 1
    }
  }
  return x
}

func m4 (b1 : Bool, b2 : Bool, b3 : Bool) -> String {
  return (b1 ? b2 : b3) ? "b2 || b3" : "!b2 || !b3"
}

func conversionsInSplitEntry (b : Bool) -> String {
  if b ? (true) : Bool(false) {
    return "b"
  }
  else {
    return "!b"
  }
}

func constant_condition() {
  if !true {
    print("Impossible")
  }
}

func empty_else(b : Bool) {
  if b {
    print("true")
  }
  else {}
  print("done")
}

func disjunct (b1 : Bool, b2 : Bool) {
  if (b1 || b2) {
    print("b1 or b2")
  }
}

func binaryExprs(a : Int, b : Int) {
  let c = a + b
  let d = a - b
  let e = a * b
  let f = a / b
  let g = a % b
  let h = a & b
  let i = a | b
  let j = a ^ b
  let k = a << b
  let l = a >> b
  let o = a == b
  let p = a != b
  let q = a < b
  let r = a <= b
  let s = a > b
  let t = a >= b
}

func interpolatedString(x : Int, y : Int) -> String {
  return "\(x) + \(y) is equal to \(x + y) and here is a zero: \(returnZero())"
}

func testSubscriptExpr() -> (Int, Int, Int, Int, Int) {
  var a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  a[0] = 0
  a[1] += 1
  a[2] -= 1
  a[3] *= 1
  a[4] /= 1
  a[5] %= 1
  a[6] &= 1
  a[7] |= 1
  a[8] ^= 1
  a[9] <<= 1
  a[10] >>= 1

  var tupleWithA = (a[0], a[1], a[2], a[3], a[4])

  var b = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
  b[0] = a[10]
  b[1] = b[0] + 1
  b[2] = b[1] - 1
  b[3] = b[2] * 1
  b[4] = b[3] / 1
  b[5] = b[4] % 1
  b[6] = b[5] & 1
  b[7] = b[6] | 1
  b[8] = b[7] ^ 1
  b[9] = b[8] << 1
  b[10] = b[9] >> 1

  let (a1, a2, a3, a4, a5) = tupleWithA
  return (a1 + b[0], a2 + b[1], a3 + b[2], a4 + b[3], a5 + b[4])
}

func loop1(x : inout Int) {
  while x >= 0 {
    print(x)
    x -= 1
  }
}

func loop2(x : inout Int) {
  while x >= 0 {
    print(x)
    x -= 1
    if x > 100 {
      break
    }
    else if x > 50 {
      continue
    }
    print("Iter")
  }
  print("Done")
}

func labeledLoop(x : inout Int) {
  outer: while x >= 0 {
    inner: while x >= 0 {
      print(x)
      x -= 1
      if x > 100 {
        break outer
      }
      else if x > 50 {
        continue inner
      }
      print("Iter")
    }
    print("Done")
  }
}

func testRepeat(x : inout Int) {
  repeat {
    print(x)
    x -= 1
  } while x >= 0
}

func loop_with_identity_expr() {
  var x = 0
  while(x < 10) {
    x += 1
  }
}

class OptionalC {
  let c: C?
  init(arg: C?) {
    c = arg
  }

  func getOptional() -> C? {
    return c
  }
}

func testOptional(c : OptionalC?) -> Int? {
  return c?.getOptional()?.getMyInt()
}

func testCapture(x : Int, y : Int) -> () -> Int {
  return { [z = x + y, t = "literal"] in
    return z
  }
}

func testTupleElement(t : (a: Int, Int, c: Int)) -> Int {
  return t.a + t.1 + t.c + (1, 2, 3).0
}

class Derived : C {
  init() {
    super.init(n: 0)
  }
}

func doWithoutCatch(x : Int) throws -> Int {
  do {
    try mightThrow(x: 0)
    print("Did not throw.")
    try! mightThrow(x: 0)
    print("Still did not throw.")
  }
  return 0
}

class Structors {
  var field: Int
  init() {
    field = 10
  }

  deinit {
    field = 0
  }
}

func dictionaryLiteral(x: Int, y: Int) -> [String: Int] {
  return ["x": x, "y": y]
}

func localDeclarations() -> Int {
  class MyLocalClass {
    var x: Int
    init() {
      x = 10
    }
  }

  struct MyLocalStruct {
    var x: Int
    init() {
      x = 10
    }
  }

  enum MyLocalEnum {
    case A
    case B
  }

  var myLocalVar : Int;

  // Error: declaration is only valid at file scope
  // extension Int {
  //   func myExtensionMethod() -> Int {
  //     return self
  //   }
  // }

  // protocol 'MyProtocol' cannot be nested inside another declaration
  //   protocol MyProtocol {
  //     func myMethod()
  //   }

  return 0
}

struct B {
  var x : Int
}

struct A {
  var b : B
  var bs : [B]
  var mayB : B?
}

func test(a : A) {
  var kpGet_b_x = \A.b.x
  var kpGet_bs_0_x = \A.bs[0].x
  var kpGet_mayB_force_x = \A.mayB!.x
  var kpGet_mayB_x = \A.mayB?.x

  var apply_kpGet_b_x = a[keyPath: kpGet_b_x]
  var apply_kpGet_bs_0_x = a[keyPath: kpGet_bs_0_x]
  var apply_kpGet_mayB_force_x = a[keyPath: kpGet_mayB_force_x]
  var apply_kpGet_mayB_x = a[keyPath: kpGet_mayB_x]
}

func testIfConfig() {
#if FOO
  1
  2
#else
  3
  4
#endif

  5

#if BAR
  6
  7
#endif

  8

#if FOO
  9
  10
#elseif true
  11
  12
#endif

  13
}

func testAvailable() -> Int {
  var x = 0;

  if #available(macOS 10, *) {
    x += 1
  }

  if #available(macOS 10.13, *) {
    x += 1
  }

  if #unavailable(iOS 10, watchOS 10, macOS 10) {
    x += 1
  }

  guard #available(macOS 12, *) else {
    x += 1
  }

  if #available(macOS 12, *), #available(iOS 12, *) {
    x += 1
  }

  return x
}

func testAsyncFor () async {
    var stream = AsyncStream(Int.self, bufferingPolicy: .bufferingNewest(5), {
        continuation in
            Task.detached {
                for i in 1...100 {
                    continuation.yield(i)
                }
                continuation.finish()
            }
    })

    for try await i in stream {
        print(i)
    }
}

func testNilCoalescing(x: Int?) -> Int {
  return x ?? 0
}

func testNilCoalescing2(x: Bool?) -> Int {
  if x ?? false {
    return 1
  } else {
    return 0
  }
}

func usesAutoclosure(_ expr: @autoclosure () -> Int) -> Int {
  return expr()
}

func autoclosureTest() {
  usesAutoclosure(1)
}

// ---

protocol MyProtocol {
	func source() -> Int
}

class MyProcotolImpl : MyProtocol {
	func source() -> Int { return 0 }
}

func getMyProtocol() -> MyProtocol { return MyProcotolImpl() }
func getMyProtocolImpl() -> MyProcotolImpl { return MyProcotolImpl() }

func sink(arg: Int) { }

func testOpenExistentialExpr(x: MyProtocol, y: MyProcotolImpl) {
	sink(arg: x.source())
	sink(arg: y.source())
	sink(arg: getMyProtocol().source())
	sink(arg: getMyProtocolImpl().source())
}

func singleStmtExpr(_ x: Int) {
  let a = switch x {
    case 0..<5: 1
    default: 2
  }
  let b = if (x < 42) { 1 } else { 2 }
}
// ---
