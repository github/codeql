var topLevelDecl : Int = 0
0
topLevelDecl + 1

func returnZero() -> Int { return 0 }

returnZero()
Double(topLevelDecl)

enum MyError: Error { // $ nonSimple='ClassLikeDeclaration -V MyError -^ BaseType -V Error'
    case error1, error2
    case error3(withParam: Int)
}

func isZero(x : Int) -> Bool {
  return x == 0
}

func mightThrow(x : Int) throws -> Void {
  guard x >= 0 else { // $ bbStep='... >= ... : false -> Block(+0)' bbStep='... >= ... : true -> GuardIfStmt(+3)'
    throw MyError.error1
  }
  guard x <= 0 else { // $ bbStep='... <= ... : false -> Block(+0)'
    throw MyError.error3(withParam: x + 1)
  }
}

func tryCatch(x : Int) -> Int {
  do {
    try mightThrow(x: 0) // $ bbStep='mightThrow(...) : exception -> CatchClause(+5)' bbStep='mightThrow(...) : successor -> try ...(+0)'
    print("Did not throw.")
    try! mightThrow(x: 0)
    print("Still did not throw.") // $ bbStep='print(...) : successor -> 0(+11)'

  } catch MyError.error1 , MyError.error2 where isZero(x: x) { // $ bbStep='OrPattern : match -> Block(+0)' bbStep='OrPattern : no-match -> CatchClause(+2)' nonSimple='CatchClause -V MyError -^ ... .error1 -> isZero -> Argument -V x -^ isZero(...) -? MyError -^ ... .error2 -^ ConditionalPattern -^ OrPattern'
    return 0
  } catch MyError.error3(let withParam) { // $ bbStep='... .error3(...) : match -> Block(+0)' bbStep='... .error3(...) : no-match -> CatchClause(+2)'
    return withParam
  } catch is MyError { // $ bbStep=' : match -> Block(+0)' bbStep=' : no-match -> CatchClause(+2)'
    print("MyError") // $ bbStep='print(...) : successor -> 0(+4)'
  } catch {
    print("Unknown error \(error)") // $ bbStep='print(...) : successor -> 0(+2)'
  }
  return 0
}

func createClosure1(s : String) -> () -> String { // $ noCfg
  return {
    return s + ""
  }
}

func createClosure2(x : Int) -> (_ : Int) -> Int { // $ noCfg
  func f(y : Int) -> Int {
    return x + y
  }
  return f
}

func createClosure3(x : Int) -> (_ : Int) -> Int { // $ noCfg
  return {
    (y) -> Int in x + y // $ bbContinues='y goto Block(-1)'
  }
}

func callClosures() { // $ noCfg
  var x1 = createClosure1(s: "")()
  var x2 = createClosure2(x: 0)(10)
  var x3 = createClosure3(x: 0)(10)
}

func maybeParseInt(s : String) -> Int? {
  var n : Int? = Int(s)
  return n
}

func forceAndBackToOptional() -> Int? { // $ noCfg
  var nBang = maybeParseInt(s:"42")!
  var n = maybeParseInt(s:"42")
  return nBang + n!
}

func testInOut() -> Int { // $ noCfg
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

  func getMyInt() -> Int { // $ noCfg
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

  let n8 = param.self.getMyInt()

  let n9 = inoutParam.myInt
  let n7 = param.getMyInt()
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
  for _ in 0...10 // $ bbStep='... ... ... : empty -> SwitchExpr(+3)' bbStep='... ... ... : non-empty -> _(+0)'
        {  } // $ bbStep='Block : successor -> _(-1)' bbStep='Block : successor -> SwitchExpr(+2)'

  switch x {
    case 0, 1: // $ bbStep='OrPattern : match -> Block(+0)' bbStep='OrPattern : no-match -> SwitchCase(+3)'
      return true
      return true // $ noCfg
    case x where // $ bbContinues='Block goto true(+3)' bbStep='ConditionalPattern : match -> Block(+0)' bbStep='ConditionalPattern : no-match -> SwitchCase(+4)'
        (x >= 2) && // $ bbStep='... >= ... : false -> x(-1)' bbStep='... >= ... : true -> x(+1)'
            x < 5: // $ bbStep='... < ... : successor -> x(-2)'
      return true
    default:
      return false
  }

  var obj : AnyObject = C(n: x) // $ noCfg
  if obj is C { // $ noCfg
    return true // $ noCfg
  }

  let xOptional: Int? = x // $ noCfg
  if case .some(let x) = xOptional { // $ noCfg
    return x == 0 // $ noCfg
  } else {
    return false // $ noCfg
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
  if x > 2 { // $ bbStep='... > ... : false -> IfExpr(+3)' bbStep='... > ... : true -> Block(+0)'
    print("x is greater than 2")
  }
  else if x <= 2 && // $ bbStep='... <= ... : false,false,false -> Block(+5)' bbStep='... <= ... : true -> x(+1)'
            x > 0 && // $ bbStep='... > ... : false,false,false -> Block(+4)' bbStep='... > ... : true -> ! ...(+1)'
            !(x == 5) { // $ bbStep='... == ... : false -> Block(+0)' bbStep='... == ... : true,false -> Block(+3)'
    print("x is 1")
  }
  else {
    print("I can't guess the number")
  }
}

func m2(b : Bool) -> Int {
  if b { // $ bbStep='b : false -> 1(+3)' bbStep='b : true -> Block(+0)'
    return 0
  }
  return 1
}

func m3(x : inout Int) -> Int {
  if x < 0 { // $ bbStep='... < ... : false -> x(+6)' bbStep='... < ... : true -> Block(+0)'
    x = -x
    if x > 10 { // $ bbStep='... > ... : false -> x(+4)' bbStep='... > ... : true -> Block(+0)'
      x = x - 1 // $ bbStep='... = ... : successor -> x(+3)'
    }
  }
  return x
}

func m4 (b1 : Bool, b2 : Bool, b3 : Bool) -> String {
  return (b1 ? // $ bbStep='b1 : false -> b3(+2)' bbStep='b1 : true -> b2(+1)'
            b2 : // $ bbStep='b2 : false,false -> "!b2 \|\| !b3"(+3)' bbStep='b2 : true,true -> "b2 \|\| b3"(+2)'
            b3) ? // $ bbStep='b3 : false,false -> "!b2 \|\| !b3"(+2)' bbStep='b3 : true,true -> "b2 \|\| b3"(+1)'
        "b2 || b3" : // $ bbStep='"b2 \|\| b3" : successor -> ReturnExpr(-3)'
        "!b2 || !b3" // $ bbStep='"!b2 \|\| !b3" : successor -> ReturnExpr(-4)'
}

func conversionsInSplitEntry (b : Bool) -> String {
  if b ? // $ bbStep='b : false -> Bool(+2)' bbStep='b : true -> true(+1)'
      (true) : // $ bbStep='true : true -> Block(+1)'
      Bool(false) { // $ bbStep='Bool(...) : false -> Block(+3)' bbStep='Bool(...) : true,true -> Block(+0)'
    return "b"
  }
  else {
    return "!b"
  }
}

func constant_condition() { // $ noCfg
  if !true {
    print("Impossible") // $ noCfg
  }
}

func empty_else(b : Bool) {
  if b { // $ bbStep='b : false -> Block(+3)' bbStep='b : true -> Block(+0)'
    print("true") // $ bbStep='print(...) : successor -> print(+3)'
  }
  else {} // $ bbStep='Block : successor -> print(+1)'
  print("done")
}

func disjunct (b1 : Bool, b2 : Bool) {
  if (b1 || b2) { // $ bbStep='b1 : false -> b2(+0)' bbStep='b1 : true,true -> Block(+0)' bbStep='b2 : true,true -> Block(+0)'
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

func testSubscriptExpr() -> (Int, Int, Int, Int, Int) { // $ noCfg
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
  while x >= 0 { // $ bbStep='WhileStmt : successor -> x(+0)' bbStep='... >= ... : true -> Block(+0)'
    print(x)
    x -= 1 // $ bbStep='... -= ... : successor -> x(-2)'
  }
}

func loop2(x : inout Int) {
  while x >= 0 { // $ bbStep='WhileStmt : successor -> x(+0)' bbStep='... >= ... : false -> print(+11)' bbStep='... >= ... : true -> Block(+0)'
    print(x)
    x -= 1
    if x > 100 { // $ bbStep='... > ... : false -> IfExpr(+3)' bbStep='... > ... : true -> Block(+0)'
      break // $ bbStep='BreakExpr : break -> print(+7)'
    }
    else if x > 50 { // $ bbStep='... > ... : false -> print(+3)' bbStep='... > ... : true -> Block(+0)'
      continue // $ bbStep='ContinueExpr : continue -> x(-7)'
    }
    print("Iter") // $ bbStep='print(...) : successor -> x(-9)'
  }
  print("Done")
}

func labeledLoop(x : inout Int) {
  outer: while x >= 0 { // $ bbStep='WhileStmt : successor -> x(+0)' bbStep='... >= ... : true -> Block(+0)'
    inner: while x >= 0 { // $ bbStep='WhileStmt : successor -> x(+0)' bbStep='... >= ... : false -> print(+11)' bbStep='... >= ... : true -> Block(+0)'
      print(x)
      x -= 1
      if x > 100 { // $ bbStep='... > ... : false -> IfExpr(+3)' bbStep='... > ... : true -> Block(+0)'
        break outer
      }
      else if x > 50 { // $ bbStep='... > ... : false -> print(+3)' bbStep='... > ... : true -> Block(+0)'
        continue inner // $ bbStep='ContinueExpr : continue -> x(-7)'
      }
      print("Iter") // $ bbStep='print(...) : successor -> x(-9)'
    }
    print("Done") // $ bbStep='print(...) : successor -> x(-12)'
  }
}

func testRepeat(x : inout Int) {
  repeat { // $ bbStep='DoWhileStmt : successor -> Block(+0)'
    print(x)
    x -= 1
  } while x >= 0 // $ bbStep='... >= ... : true -> Block(-3)'
}

func loop_with_identity_expr() { // $ noCfg
  var x = 0
  while(x < 10) { // $ bbStep='WhileStmt : successor -> x(+0)' bbStep='... < ... : true -> Block(+0)'
    x += 1 // $ bbStep='... += ... : successor -> x(-1)'
  }
}

class OptionalC {
  let c: C?
  init(arg: C?) {
    c = arg
  }

  func getOptional() -> C? { // $ noCfg
    return c
  }
}

func testOptional(c : OptionalC?) -> Int? {
  return c?.getOptional()?.getMyInt()
}

func testCapture(x : Int, y : Int) -> () -> Int { // $ noCfg
  return { [z = x + y, t = "literal"] in
    return z
  }
}

func testTupleElement(t : (a: Int, Int, c: Int)) -> Int {
  return t.a + t.1 + t.c + (1, 2, 3).0
}

class Derived : C { // $ nonSimple='ClassLikeDeclaration -V Derived -^ BaseType -V C'
  init() { // $ noCfg
    super.init(n: 0)
  }
}

func doWithoutCatch(x : Int) throws -> Int {
  do {
    try mightThrow(x: 0) // $ bbStep='mightThrow(...) : successor -> try ...(+0)'
    print("Did not throw.")
    try! mightThrow(x: 0)
    print("Still did not throw.")
  }
  return 0
}

class Structors {
  var field: Int
  init() { // $ noCfg
    field = 10
  }

  deinit {
    field = 0
  }
}

func dictionaryLiteral(x: Int, y: Int) -> [String: Int] {
  return ["x": x, "y": y]
}

func localDeclarations() -> Int { // $ noCfg
  class MyLocalClass {
    var x: Int
    init() { // $ noCfg
      x = 10
    }
  }

  struct MyLocalStruct {
    var x: Int
    init() { // $ noCfg
      x = 10
    }
  }

  enum MyLocalEnum {
    case A
    case B
  }

  var myLocalVar : Int;

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

func testIfConfig() { // $ noCfg
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

func testAvailable() -> Int { // $ noCfg
  var x = 0;

  if #available(macOS 10, *) { // $ bbStep=' : false -> IfExpr(+4)' bbStep=' : true -> Block(+0)'
    x += 1 // $ bbStep='... += ... : successor -> IfExpr(+3)'
  }

  if #available(macOS 10.13, *) { // $ bbStep=' : false -> IfExpr(+4)' bbStep=' : true -> Block(+0)'
    x += 1 // $ bbStep='... += ... : successor -> IfExpr(+3)'
  }

  if #unavailable(iOS 10, watchOS 10, macOS 10) { // $ bbStep=' : false -> GuardIfStmt(+4)' bbStep=' : true -> Block(+0)'
    x += 1 // $ bbStep='... += ... : successor -> GuardIfStmt(+3)'
  }

  guard #available(macOS 12, *) else { // $ bbStep=' : false -> Block(+0)' bbStep=' : true -> IfExpr(+4)'
    x += 1 // $ bbStep='... += ... : successor -> IfExpr(+3)'
  }

  if #available(macOS 12, *), // $ bbStep=' : true -> (+1)' bbStep=' : false,false -> x(+5)'
      #available(iOS 12, *) { // $ bbStep=' : false,false -> x(+4)' bbStep=' : true -> Block(+0)'
    x += 1 // $ bbStep='... += ... : successor -> x(+3)'
  }

  return x
}

func testAsyncFor () async { // $ noCfg
    var stream = AsyncStream(Int.self, bufferingPolicy: .bufferingNewest(5), { // $ bbContinues='Block goto Task(+2)'
        continuation in // $ bbContinues='continuation goto Block(-1)'
            Task.detached { // $ nonSimple='Task -^ ... .detached -^ Argument -V FunctionExpr -^ ... .detached(...)'
                for i in 1...100 { // $ bbStep='... ... ... : empty -> continuation(+3)' bbStep='... ... ... : non-empty -> i(+0)'
                    continuation.yield(i) // $ bbStep='... .yield(...) : successor -> continuation(+2)' bbStep='... .yield(...) : successor -> i(-1)'
                }
                continuation.finish()
            }
    })

    for try await i in stream { // $ bbStep='stream : non-empty -> i(+0)'
        print(i) // $ bbStep='print(...) : successor -> i(-1)'
    }
}

func testNilCoalescing(x: Int?) -> Int {
  return
    x ?? // $ bbStep='x : non-null -> ReturnExpr(-1)' bbStep='x : null -> 0(+1)'
        0 // $ bbStep='0 : successor -> ReturnExpr(-2)'
}

func testNilCoalescing2(x: Bool?) -> Int {
  if x ?? // $ bbStep='x : non-null,false -> Block(+3)' bbStep='x : non-null,true -> Block(+1)' bbStep='x : null -> false(+1)'
      false { // $ bbStep='false : false -> Block(+2)'
    return 1
  } else {
    return 0
  }
}

func usesAutoclosure(_ expr: @autoclosure () -> Int) -> Int {
  return expr()
}

func autoclosureTest() { // $ noCfg
  usesAutoclosure(1)
}

// ---

protocol MyProtocol {
	func source() -> Int
}

class MyProcotolImpl : MyProtocol { // $ nonSimple='ClassLikeDeclaration -V MyProcotolImpl -^ BaseType -V MyProtocol'
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
    case 0..<5: 1 // $ bbStep='1 : successor -> VariableDeclaration(+3)' bbStep='... ..< ... : match -> Block(+0)' bbStep='... ..< ... : no-match -> SwitchCase(+1)'
    default: 2 // $ bbStep='2 : successor -> VariableDeclaration(+2)'
  }
  let b =
        if (x < 42) { 1 } // $ bbStep='... < ... : false -> Block(+1)' bbStep='... < ... : true -> Block(+0)'
        else { 2 }
}
// ---

struct ValueGenericsStruct<let N: Int> {
    var x = N;
}

func valueGenericsFn<let N: Int>(_ value: ValueGenericsStruct<N>) {
    var x = N;
    print(x);
    _ = value;
}
