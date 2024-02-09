func source() -> Int { return 0; }
func sink<T>(arg: T) {}

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
    sink(arg: clean) // clean
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
    sink(arg: x ?? source()) // $ flow=259 flow=275
    sink(arg: y ?? 0)
    sink(arg: y ?? source()) // $ flow=277

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
        sink(arg: z) // $ flow=259
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
    sink(arg: a) // $ flow=351
    sink(arg: b) // $ flow=351
    sink(arg: c)
}

func tupleShiftLeft1(_ t: (Int, Int)) -> (Int, Int) {
    return (t.1, 0)
}

func tupleShiftLeft2(_ t: (Int, Int)) -> (Int, Int) { return (0, 0) } // modelled flow

func testTuples3() {
    let t1 = (1, source())
    let t2 = tupleShiftLeft1(t1)
    let t3 = tupleShiftLeft2(t1)

    sink(arg: t1.0)
    sink(arg: t1.1) // $ flow=375
    sink(arg: t2.0) // $ flow=375
    sink(arg: t2.1)
    sink(arg: t3.0) // $ flow=375
    sink(arg: t3.1)
}

indirect enum MyEnum {
    case myNone
    case mySingle(Int)
    case myPair(Int, Int)
    case myCons(Int, MyEnum)
}

func mkMyEnum1(_ v: Int) -> MyEnum { return MyEnum.mySingle(v) }
func mkMyEnum2(_ v: Int) -> MyEnum { return MyEnum.myNone } // modelled flow
func mkOptional1(_ v: Int) -> Int? { return Optional.some(v) }
func mkOptional2(_ v: Int) -> Int? { return nil } // modelled flow

func testEnums() {
    var a : MyEnum = .myNone

    switch a {
    case .myNone:
        ()
    case .mySingle(let a):
        sink(arg: a)
    case .myPair(let a, let b):
        sink(arg: a)
        sink(arg: b)
    case let .myCons(a, _):
        sink(arg: a)
    }

    if case .mySingle(let x) = a {
        sink(arg: x)
    }
    if case .myPair(let x, let y) = a {
        sink(arg: x)
        sink(arg: y)
    }

    a = .mySingle(source())

    switch a {
    case .myNone:
        ()
    case .mySingle(let a):
        sink(arg: a) // $ flow=422
    case .myPair(let a, let b):
        sink(arg: a)
        sink(arg: b)
    case let .myCons(a, _):
        sink(arg: a)
    }

    if case .mySingle(let x) = a {
        sink(arg: x) // $ flow=422
    }
    if case .myPair(let x, let y) = a {
        sink(arg: x)
        sink(arg: y)
    }

    a = MyEnum.myPair(0, source())

    switch a {
    case .myNone:
        ()
    case .mySingle(let a):
        sink(arg: a)
    case .myPair(let a, let b):
        sink(arg: a)
        sink(arg: b) // $ flow=444
    case let .myCons(a, _):
        sink(arg: a)
    }

    if case .mySingle(let x) = a {
        sink(arg: x)
    }
    if case .myPair(let x, let y) = a {
        sink(arg: x)
        sink(arg: y) // $ flow=444
    }

    let b: MyEnum = .myCons(42, a)

    switch b {
    case .myNone:
        ()
    case .mySingle(let a):
        sink(arg: a)
    case .myPair(let a, let b):
        sink(arg: a)
        sink(arg: b)
    case let .myCons(a, .myPair(b, c)):
        sink(arg: a)
        sink(arg: b)
        sink(arg: c) // $ flow=444
    case let .myCons(a, _):
        sink(arg: a)
    }

    if case .mySingle(let x) = MyEnum.myPair(source(), 0) {
        sink(arg: x)
    }
    if case MyEnum.myPair(let x, let y) = .myPair(source(), 0) {
        sink(arg: x) // $ flow=487
        sink(arg: y)
    }
    if case let .myCons(_, .myPair(_, c)) = b {
        sink(arg: c) // $ flow=444
    }

    switch (a, b) {
    case let (.myPair(a, b), .myCons(c, .myPair(d, e))):
        sink(arg: a)
        sink(arg: b) // $ flow=444
        sink(arg: c)
        sink(arg: d)
        sink(arg: e) // $ flow=444
    default:
        ()
    }

    let c1 = MyEnum.mySingle(0)
    let c2 = MyEnum.mySingle(source())
    let c3 = mkMyEnum1(0)
    let c4 = mkMyEnum1(source())
    let c5 = mkMyEnum2(0)
    let c6 = mkMyEnum2(source())
    if case MyEnum.mySingle(let d1) = c1 { sink(arg: d1) }
    if case MyEnum.mySingle(let d2) = c2 { sink(arg: d2) } // $ flow=507
    if case MyEnum.mySingle(let d3) = c3 { sink(arg: d3) }
    if case MyEnum.mySingle(let d4) = c4 { sink(arg: d4) } // $ flow=509
    if case MyEnum.mySingle(let d5) = c5 { sink(arg: d5) }
    if case MyEnum.mySingle(let d6) = c6 { sink(arg: d6) } // $ flow=511

    let e1 = Optional.some(0)
    let e2 = Optional.some(source())
    let e3 = mkOptional1(0)
    let e4 = mkOptional1(source())
    let e5 = mkOptional2(0)
    let e6 = mkOptional2(source())
    sink(arg: e1!)
    sink(arg: e2!) // $ flow=520
    sink(arg: e3!)
    sink(arg: e4!) // $ flow=522
    sink(arg: e5!)
    sink(arg: e6!) // $ flow=524
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
        sink(arg: a) // $ flow=259
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
  sink(arg: +source()) // $ flow=576
  sink(arg: (source())) // $ flow=577
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
      sink(str: str) // $ flow=593
    }
}

func extensionInits(path: String) {
  sink(str: MyClass(s: source3()).str) // $ flow=599
  sink(str: MyClass(contentsOfFile: path).str) // $ flow=593
}

class InoutConstructorClass {
  init(_ n : inout Int) { n = source() }
}

func sink(arg: InoutConstructorClass) {}

func inoutConstructor() {
  var n = 0
  sink(arg: InoutConstructorClass(&n))
}

struct S {
  var x: Int

  init(x: Int) {
    self.x = x
  }
}

func testKeyPath() {
  let s = S(x: source())
  let f = \S.x
  sink(arg: s[keyPath: f]) // $ flow=623

  let inferred : KeyPath<S, Int> = \.x
  sink(arg: s[keyPath: inferred]) // $ flow=623
}

struct S2 {
  var s: S

  init(s: S) {
    self.s = s
  }
}

func testNestedKeyPath() {
  let s = S(x: source())
  let s2 = S2(s: s)
  let f = \S2.s.x
  sink(arg: s2[keyPath: f]) // $ flow=640
}

func testArrayKeyPath() {
    let array = [source()]
    let f = \[Int].[0]
    sink(arg: array[keyPath: f]) // $ flow=647
}

struct S2_Optional {
  let s: S?

  init(s: S?) {
    self.s = s
  }
}

func testOptionalKeyPath() {
    let s = S(x: source())
    let s2 = S2_Optional(s: s)
    let f = \S2_Optional.s?.x
    sink(arg: s2[keyPath: f]!) // $ flow=661
}

func testSwap() {
    var x = source()
    var y = 0
    var t: Int

    t = x
    x = y
    y = t
    sink(arg: x)
    sink(arg: y) // $ flow=668

    x = source()
    y = 0
    swap(&x, &y)
    sink(arg: x) // $ SPURIOUS: flow=678
    sink(arg: y) // $ flow=678
}

func testArray() {
    var arr1 = [1,2,3]
    sink(arg: arr1[0])
    arr1[1] = source()
    sink(arg: arr1[0]) // $ flow=688
    sink(arg: arr1)

    var arr2 = [source()]
    sink(arg: arr2[0]) // $ flow=692

    var matrix = [[source()]]
    sink(arg: matrix[0])
    sink(arg: matrix[0][0]) // $ flow=695

    var matrix2 = [[1]]
    matrix2[0][0] = source()
    sink(arg: matrix2[0][0]) // $ flow=700

    var arr3 = [1]
    var arr4 = arr2 + arr3
    sink(arg: arr3[0])
    sink(arg: arr4[0]) // $ MISSING: flow=692

    var arr5 = Array(repeating: source(), count: 2)
    sink(arg: arr5[0]) // $ flow=708

    var arr6 = [1,2,3]
    arr6.insert(source(), at: 2)
    sink(arg: arr6[0]) // $ flow=712

    var arr7 = [source()]
    sink(arg: arr7.randomElement()!) // $ flow=715
}

func testSetCollections() {
    var set1: Set = [1,2,3]
    sink(arg: set1.randomElement()!)
    set1.insert(source())
    sink(arg: set1.randomElement()!) // $ flow=722

    let set2 = Set([source()])
    sink(arg: set2.randomElement()!) // $ flow=725
}

struct MyOptionals {
    var v1 : Int? = 0
    var v2 : Int? = 0
    var v3 : Int! = 0
}

func testWriteOptional() {
    var v1 : Int? = 0
    var v2 : Int? = 0
    var v3 : Int! = 0
    var mo1 = MyOptionals()
    var mo2 : MyOptionals! = MyOptionals()

    v1! = source()
    v2 = source()
    v3 = source()
    mo1.v1! = source()
    mo1.v2 = source()
    mo1.v3 = source()
    mo2!.v1! = source()
    mo2!.v2 = source()
    mo2!.v3 = source()

    sink(arg: v1!) // $ flow=742
    sink(arg: v2!) // $ flow=743
    sink(arg: v3) // $ flow=744
    sink(arg: mo1.v1!) // $ MISSING:flow=745
    sink(arg: mo1.v2!) // $ flow=746
    sink(arg: mo1.v3) // $ flow=747
    sink(arg: mo2!.v1!) // $ MISSING:flow=748
    sink(arg: mo2!.v2!) // $ MISSING:flow=749
    sink(arg: mo2!.v3) // $ MISSING:flow=750
}

func testOptionalKeyPathForce() {
    let s = S(x: source())
    let s2 = S2_Optional(s: s)
    let f = \S2_Optional.s!.x
    sink(arg: s2[keyPath: f]) // $ flow=764
}

func testDictionary() {
    var dict1 = [1:2, 3:4, 5:6]
    sink(arg: dict1[1])

    dict1[1] = source()

    sink(arg: dict1[1]) // $ flow=774

    var dict2 = [source(): 1]
    sink(arg: dict2[1])

    for (key, value) in dict2 {
        sink(arg: key) // $ flow=778
        sink(arg: value)
    }

    var dict3 = [1: source()]
    sink(arg: dict3[1]) // $ flow=786

    dict3[source()] = 2

    sink(arg: dict3.randomElement()!.0) // $ flow=789
    sink(arg: dict3.randomElement()!.1) // $ flow=786

    for (key, value) in dict3 {
        sink(arg: key) // $ flow=789
        sink(arg: value) // $ flow=786
    }

    var dict4 = [1:source()]
    sink(arg: dict4.updateValue(1, forKey: source())!) // $ flow=799
    sink(arg: dict4.updateValue(source(), forKey: 2)!) // $ SPURIOUS: flow=799
    sink(arg: dict4.randomElement()!.0) // $ flow=800
    sink(arg: dict4.randomElement()!.1) // $ flow=799 flow=801
    sink(arg: dict4.keys.randomElement()) // $ MISSING: flow=800
    sink(arg: dict4.values.randomElement()) // $ MISSING: flow=799 flow=801
}

struct S3 {
  init(_ v: Int) {
    self.v = v
  }

  func getv() -> Int { return v }

  var v: Int
}

func testStruct() {
    var s1 = S3(source())
    var s2 = S3(0)

    sink(arg: s1.v) // $ flow=819
    sink(arg: s2.v)
    sink(arg: s1.getv()) // $ flow=819
    sink(arg: s2.getv())

    s1.v = 0
    s2.v = source()

    sink(arg: s1.v)
    sink(arg: s2.v) // $ flow=828
    sink(arg: s1.getv())
    sink(arg: s2.getv()) // $ flow=828
}

func testNestedKeyPathWrite() {
  var s2 = S2(s: S(x: 1))
  sink(arg: s2.s.x)
  var f = \S2.s.x
  s2[keyPath: f] = source()
  sink(arg: s2.s.x) // $ flow=840
}

func testVarargs1(args: Int...) {
    sink(arg: args)
    sink(arg: args[0]) // $ flow=871
}

func testVarargs2(_ v: Int, _ args: Int...) {
    sink(arg: v) // $ flow=872
    sink(arg: args)
    sink(arg: args[0])
    sink(arg: args[1])
}

func testVarargs3(_ v: Int, _ args: Int...) {
    sink(arg: v)
    sink(arg: args)
    sink(arg: args[0]) // $ SPURIOUS: flow=873
    sink(arg: args[1]) // $ flow=873

    for arg in args {
        sink(arg: arg) // $ flow=873
    }

    let myKeyPath = \[Int][1]
    sink(arg: args[keyPath: myKeyPath]) // $ flow=873
}

func testVarargsCaller() {
    testVarargs1(args: source())
    testVarargs2(source(), 2, 3)
    testVarargs3(1, 2, source())
}

func testSetForEach() {
    var set1 = Set([source()])

    for elem in set1 {
        sink(arg: elem) // $ flow=877
    }

    var generator = set1.makeIterator()
    sink(arg: generator.next()!) // $ flow=877
}

func testAsyncFor () async {
    var stream = AsyncStream(Int.self, bufferingPolicy: .bufferingNewest(5), {
        continuation in
            Task.detached {
                for _ in 1...100 {
                    continuation.yield(source())
                }
                continuation.finish()
            }
    })

    for try await i in stream {
        sink(arg: i) // $ MISSING: flow=892
    }
}

func usesAutoclosure(_ expr: @autoclosure () -> Int) {
  sink(arg: expr()) // $ flow=908
}

func autoclosureTest() {
  usesAutoclosure(source())
}

// ---

protocol MyProtocol {
	func source(_ label: String) -> Int
}

class MyProcotolImpl : MyProtocol {
	func source(_ label: String) -> Int { return 0 }
}

func getMyProtocol() -> MyProtocol { return MyProcotolImpl() }
func getMyProtocolImpl() -> MyProcotolImpl { return MyProcotolImpl() }

func sink(arg: Int) { }

func testOpenExistentialExpr(x: MyProtocol, y: MyProcotolImpl) {
	sink(arg: x.source("x.source")) // $ flow=x.source
	sink(arg: y.source("y.source")) // $ flow=y.source
	sink(arg: getMyProtocol().source("getMyProtocol.source")) // $ flow=getMyProtocol.source
	sink(arg: getMyProtocolImpl().source("getMyProtocolImpl.source")) // $ flow=getMyProtocolImpl.source
}

// ---

@propertyWrapper struct MyTaintPropertyWrapper {
    var wrappedValue: Int {
        get { return source() }
        set { sink(arg: newValue) } // $ flow=943 flow=950
    }

    init(wrappedValue: Int) {
        sink(arg: wrappedValue) // $ flow=948
        self.wrappedValue = source()
    }
}

func test_my_taint_property_wrapper() {
    @MyTaintPropertyWrapper var x: Int = source()
    sink(arg: x) // $ flow=937
    x = source()
    sink(arg: x) // $ flow=937
}

// ---

@propertyWrapper struct MySimplePropertyWrapper {
    var wrappedValue: Int {
        didSet {
            sink(arg: wrappedValue) // $ flow=980 flow=991
        }
    }

    var projectedValue: Int {
        get { wrappedValue }
        set {
            sink(arg: wrappedValue) // $ MISSING: flow=991
            wrappedValue = newValue
        }
    }

    init(wrappedValue: Int) {
        sink(arg: wrappedValue) // $ flow=983
        self.wrappedValue = wrappedValue
    }
}

func test_my_property_wrapper() {
    @MySimplePropertyWrapper var a = 0
    sink(arg: a)
    a = source()
    sink(arg: a) // $ MISSING: flow=980

    @MySimplePropertyWrapper var b = source()
    sink(arg: b) // $ MISSING: flow=983
    b = 0
    sink(arg: b)

    @MySimplePropertyWrapper var c = 0
    sink(arg: c)
    sink(arg: $c)
    $c = source()
    sink(arg: c) // $ MISSING: flow=991
    sink(arg: $c) // $ MISSING: flow=991
}
