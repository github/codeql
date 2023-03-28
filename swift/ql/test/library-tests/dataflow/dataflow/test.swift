func source() -> Int { return 0; }
func sink(arg: Int) {}

func intraprocedural_with_local_flow() -> Void {
    var t2: Int
    var t1: Int = source()
    sink(arg: t1) // $ flow=6
    t2 = t1
    sink(arg: t1) // $ flow=6
    sink(arg: t2) // $ flow=6
    if(t1 != 0) {
        t2 = 0
        sink(arg: t2)
    }
    sink(arg: t2) // $ MISSING: flow=6

    t1 = 0;
    while(false) {
        t1 = t2
    }
    sink(arg: t1)
}

func caller_source() -> Void {
    callee_sink(x: source(), y: 1)
    callee_sink(x: 1, y: source())
}

func callee_sink(x: Int, y: Int) -> Void {
    sink(arg: x) // $ flow=25
    sink(arg: y) // $ flow=26
}

func callee_source() -> Int {
    return source()
}

func caller_sink() -> Void {
    sink(arg: callee_source()) // $ flow=35
}

func branching(b: Bool) -> Void {
    var t1: Int = source()
    var t: Int = 0
    if(b) {
        t = t1;
    } else {
        t = 1;
    }
    sink(arg: t) // $ flow=43
}

func inoutSource(arg: inout Int) -> Void {
    arg = source()
    return
}

func inoutUser() {
    var x: Int = 0
    sink(arg: x)
    inoutSource(arg: &x)
    sink(arg: x) // $ flow=54
}

func inoutSwap(arg1: inout Int, arg2: inout Int) -> Void {
    var temp: Int = arg1
    arg1 = arg2
    arg2 = temp
    return
}

func swapUser() {
    var x: Int = source()
    var y: Int = 0
    inoutSwap(arg1: &x, arg2: &y)
    sink(arg: x) // $ SPURIOUS: flow=73
    sink(arg: y) // $ flow=73
}

func inoutSourceWithoutReturn(arg: inout Int) {
    arg = source()
}

func inoutSourceMultipleReturn(arg: inout Int, bool: Bool) {
    if(bool) {
        arg = source()
        return
    } else {
        arg = source()
    }
}

func inoutUser2(bool: Bool) {
    do {
        var x: Int = 0
        sink(arg: x) // clean
        inoutSourceWithoutReturn(arg: &x)
        sink(arg: x)  // $ flow=81
    }

    do {
        var x: Int = 0
        sink(arg: x) // clean
        inoutSourceMultipleReturn(arg: &x, bool: bool)
        sink(arg: x) // $ flow=86 flow=89
    }
}

func id(arg: Int) -> Int {
    return arg
}

func forward(arg: Int, lambda: (Int) -> Int) -> Int {
    return lambda(arg)
}

func forwarder() {
    var x: Int = source()
    var y: Int = forward(arg: x, lambda: id)
    sink(arg: y) // $ flow=118

    var z: Int = forward(arg: source(), lambda: {
        (i: Int) -> Int in
        return i
    })
    sink(arg: z) // $ flow=122

    var clean: Int = forward(arg: source(), lambda: {
        (i: Int) -> Int in
        return 0
    })
    sink(arg: clean)
}

func lambdaFlows() {
    var lambda1 = {
        () -> Void in
        sink(arg: source()) // $ flow=138
    }

    var lambda2 = {
        (i: Int) -> Int in
        return i
    }
    sink(arg: lambda2(source())) // $ flow=145

    var lambdaSource = {
        () -> Int in
        return source()
    }
    sink(arg: lambdaSource()) // $ flow=149

    var lambdaSink = {
        (i: Int) -> Void in
        sink(arg: i) // $ flow=157 flow=149
    }
    lambdaSink(source())

    lambdaSink(lambdaSource())
}

class A {
  var x : Int

  init() {
    x = 0
  }

  func set(_ value : Int) {
    x = value
  }

  func get() -> Int {
    return x
  }
}

func simple_field_flow() {
  var a = A()
  a.x = source()
  sink(arg: a.x) // $ flow=180
}

class B {
  var a : A

  init() {
    a = A()
  }
}

func reverse_read() {
  var b = B()
  b.a.x = source()
  sink(arg: b.a.x) // $ flow=194
}

func test_setter() {
  var a = A()
  a.set(source())
  sink(arg: a.x) // $ flow=200
}

func test_getter() {
  var a = A()
  a.x = source()
  sink(arg: a.get()) // $ flow=206
}

func test_setter_getter() {
  var a = A()
  a.set(source())
  sink(arg: a.get()) // $ flow=212
}

func flow_through(b : B) {
  var b = B()
  b.a.set(source())
  sink(arg: b.a.x) // $ flow=218
}

class HasComputedProperty {
  var source_value : Int {
    get {
      return source()
    }
    set {

    }
  }
}

func test_computed_property() {
  var a = HasComputedProperty()
  sink(arg: a.source_value) // $ flow=225

  a.source_value = 0
  sink(arg: a.source_value) // $ flow=225
}

@propertyWrapper struct DidSetSource {
    var wrappedValue: Int {
        didSet { wrappedValue = source() }
    }

    init(wrappedValue: Int) {
        self.wrappedValue = 0
    }
}

func test_property_wrapper() {
    @DidSetSource var x = 42
    sink(arg: x) // $ MISSING: flow=243
}

func sink(opt: Int?) {}

func optionalSource() -> Int? {
    return source()
}

func test_optionals(y: Int?) {
    let x = optionalSource()

    sink(opt: x) // $ flow=259
    sink(opt: y)
    sink(arg: x!) // $ flow=259
    sink(arg: y!)

    sink(arg: source().signum()) // $ flow=270
    sink(opt: x?.signum()) // $ flow=259
    sink(opt: y?.signum())

    sink(arg: x ?? 0) // $ flow=259
    sink(arg: x ?? source()) // $ flow=259 MISSING: flow=276
    sink(arg: y ?? 0)
    sink(arg: y ?? source()) // $ MISSING: flow=278

    sink(arg: x != nil ? x! : 0) // $ flow=259
    sink(arg: x != nil ? x! : source()) // $ flow=259 flow=280
    sink(arg: y != nil ? y! : 0)
    sink(arg: y != nil ? y! : source()) // $ flow=282

    if let z = x {
        sink(arg: z) // $ flow=259
    }
    if let z = y {
        sink(arg: z)
    }

    if let z = x?.signum() {
        sink(arg: z) // $ flow=259
    }
    if let z = y?.signum() {
        sink(arg: z)
    }

    guard let z1 = x else { return }
    guard let z2 = y else { return }
    sink(arg: z1) // $ flow=259
    sink(arg: z2)

    sink(arg: x!.signum()) // $ flow=259
    sink(arg: y!.signum())

    if case .some(let z) = x {
        sink(arg: z) // $ flow=259
    }
    if case .some(let z) = y {
        sink(arg: z)
    }

    switch x {
    case .some(let z):
        sink(arg: z) // $ MISSING: flow=259
    case .none:
        ()
    }
    switch y {
    case .some(let z):
        sink(arg: z)
    case .none:
        ()
    }
}

func sink(arg: (Int, Int)) {}
func sink(arg: (Int, Int, Int)) {}

func testTuples() {
    var t1 = (1, source())

    sink(arg: t1)
    sink(arg: t1.0)
    sink(arg: t1.1) // $ flow=331

    t1.1 = 2

    sink(arg: t1)
    sink(arg: t1.0)
    sink(arg: t1.1)

    t1.0 = source()

    sink(arg: t1)
    sink(arg: t1.0) // $ flow=343
    sink(arg: t1.1)
}

func testTuples2() {
    let t1 = (x: source(), y: source(), z: 0)
    let t2 = t1
    let (a, b, c) = t1

    sink(arg: t1)
    sink(arg: t1.x) // $ flow=351
    sink(arg: t1.y) // $ flow=351
    sink(arg: t1.z)
    sink(arg: t2)
    sink(arg: t2.x) // $ flow=351
    sink(arg: t2.y) // $ flow=351
    sink(arg: t2.z)
    sink(arg: a) // $ MISSING: flow=351
    sink(arg: b) // $ MISSING: flow=351
    sink(arg: c)
}

enum MyEnum {
    case myNone
    case mySingle(Int)
    case myPair(Int, Int)
}

func testEnums() {
    let a : MyEnum = .myNone

    switch a {
    case .myNone:
        ()
    case .mySingle(let a):
        sink(arg: a)
    case .myPair(let a, let b):
        sink(arg: a)
        sink(arg: b)
    }

    if case .mySingle(let x) = a {
        sink(arg: x)
    }
    if case .myPair(let x, let y) = a {
        sink(arg: x)
        sink(arg: y)
    }

    let b : MyEnum = .mySingle(source())

    switch b {
    case .myNone:
        ()
    case .mySingle(let a):
        sink(arg: a) // $ MISSING: flow=395
    case .myPair(let a, let b):
        sink(arg: a)
        sink(arg: b)
    }

    if case .mySingle(let x) = a {
        sink(arg: x) // $ MISSING: flow=395
    }
    if case .myPair(let x, let y) = a {
        sink(arg: x)
        sink(arg: y)
    }

    let c = MyEnum.myPair(0, source())

    switch c {
    case .myNone:
        ()
    case .mySingle(let a):
        sink(arg: a)
    case .myPair(let a, let b):
        sink(arg: a)
        sink(arg: b) // $ MISSING: flow=415
    }

    if case .mySingle(let x) = a {
        sink(arg: x)
    }
    if case .myPair(let x, let y) = a {
        sink(arg: x)
        sink(arg: y) // $ MISSING: flow=415
    }
}

func source2() -> (Int, Int)? { return nil }

func testOptionals2(y: Int?) {
    let x = optionalSource()

    if let a = x, let b = y {
        sink(arg: a) // $ flow=259
        sink(arg: b)
    }

    let tuple1 = (x, y)
    switch tuple1 {
    case (.some(let a), .some(let b)):
        sink(arg: a) // $ MISSING: flow=259
        sink(arg: b)
    default:
        ()
    }

    if let (x, y) = source2() {
        sink(arg: x) // (taint but not data flow)
        sink(arg: y) // (taint but not data flow)
    }
}

class C {
    var x: Int?
}

func testOptionalPropertyAccess(y: Int?) {
    let x = optionalSource()
    let cx = C()
    cx.x = x
    let cy = C()
    cy.x = y

    guard let z1 = cx.x else { return }
    sink(arg: z1) // $ flow=259
    guard let z2 = cy.x else { return }
    sink(arg: z2)
}

func testIdentityArithmetic() {
  sink(arg: +source()) // $ flow=479
  sink(arg: (source())) // $ flow=480
}

func sink(str: String) {}

func source3() -> String { return "" }

class MyClass {
    var str: String
    init(s: String) {
      str = s
    }
}

extension MyClass {
    convenience init(contentsOfFile: String) {
      self.init(s: source3()) 
      sink(str: str) // $ flow=496
    }
}

func extensionInits(path: String) {
  sink(str: MyClass(s: source3()).str) // $ flow=502
  sink(str: MyClass(contentsOfFile: path).str) // $ flow=496
}

class InoutConstructorClass {
  init(_ n : inout Int) { n = source() }
}

func sink(arg: InoutConstructorClass) {}

func inoutConstructor() {
  var n = 0
  sink(arg: InoutConstructorClass(&n))
}