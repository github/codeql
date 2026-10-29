// --- Overload by parameter type ---

class OverloadByType {
  // OverloadByType.handle(_:Int)
  func handle(_ x: Int) -> String {
    return "int"
  }

  // OverloadByType.handle(_:Double)
  func handle(_ x: Double) -> String {
    return "double"
  }

  // OverloadByType.handle(_:String)
  func handle(_ x: String) -> String {
    return "string"
  }

  // OverloadByType.handle(_:Bool)
  func handle(_ x: Bool) -> String {
    return "bool"
  }
}

func testOverloadByType() {
  let o = OverloadByType() // $ target=init()
  let r1 = o.handle(42) // $ type=r1:String target=OverloadByType.handle(_:Int)
  let r2 = o.handle(3.14) // $ type=r2:String target=OverloadByType.handle(_:Double)
  let r3 = o.handle("hi") // $ type=r3:String target=OverloadByType.handle(_:String)
  let r4 = o.handle(true) // $ type=r4:String target=OverloadByType.handle(_:Bool)
}

// --- Overload by argument label ---

class OverloadByLabel {
  // OverloadByLabel.configure(width:)
  func configure(width: Int) -> String {
    return "width"
  }

  // OverloadByLabel.configure(height:)
  func configure(height: Int) -> String {
    return "height"
  }

  // OverloadByLabel.configure(width:height:)
  func configure(width: Int, height: Int) -> String {
    return "both"
  }

  // OverloadByLabel.configure(size:)
  func configure(size: Int) -> String {
    return "size"
  }
}

func testOverloadByLabel() {
  let o = OverloadByLabel() // $ target=init()
  let r1 = o.configure(width: 10) // $ type=r1:String target=OverloadByLabel.configure(width:)
  let r2 = o.configure(height: 20) // $ type=r2:String target=OverloadByLabel.configure(height:)
  let r3 = o.configure(width: 10, height: 20) // $ type=r3:String target=OverloadByLabel.configure(width:height:)
  let r4 = o.configure(size: 30) // $ type=r4:String target=OverloadByLabel.configure(size:)
}

// --- Overload by arity (number of parameters) ---

class OverloadByArity {
  // OverloadByArity.compute()
  func compute() -> Int {
    return 0
  }

  // OverloadByArity.compute(_:Int)
  func compute(_ x: Int) -> Int {
    return x
  }

  // OverloadByArity.compute(_:Int,_:Int)
  func compute(_ x: Int, _ y: Int) -> Int {
    return x + y
  }

  // OverloadByArity.compute(_:Int,_:Int,_:Int)
  func compute(_ x: Int, _ y: Int, _ z: Int) -> Int {
    return x + y + z
  }
}

func testOverloadByArity() {
  let o = OverloadByArity() // $ target=init()
  let r0 = o.compute() // $ type=r0:Int target=OverloadByArity.compute()
  let r1 = o.compute(1) // $ type=r1:Int target=OverloadByArity.compute(_:Int)
  let r2 = o.compute(1, 2) // $ type=r2:Int target=OverloadByArity.compute(_:Int,_:Int)
  let r3 = o.compute(1, 2, 3) // $ type=r3:Int target=OverloadByArity.compute(_:Int,_:Int,_:Int)
}

// --- Overload by return type (contextual type) ---

class OverloadByReturn {
  // OverloadByReturn.create()->Int
  func create() -> Int {
    return 0
  }

  // OverloadByReturn.create()->String
  func create() -> String {
    return ""
  }

  // OverloadByReturn.create()->Double
  func create() -> Double {
    return 0.0
  }
}

func testOverloadByReturn() {
  let o = OverloadByReturn() // $ target=init()
  let r1 : Int = o.create() // $ type=r1:Int target=OverloadByReturn.create()->Int
  let r2 : String = o.create() // $ type=r2:String target=OverloadByReturn.create()->String
  let r3 : Double = o.create() // $ type=r3:Double target=OverloadByReturn.create()->Double
}

// --- Overload: generic vs non-generic (non-generic preferred) ---

class OverloadGenericVsConcrete {
  // OverloadGenericVsConcrete.process(_:Int)
  func process(_ x: Int) -> String {
    return "concrete"
  }

  // OverloadGenericVsConcrete.process<T>(_:)
  func process<T>(_ x: T) -> String {
    return "generic"
  }
}

func testOverloadGenericVsConcrete() {
  let o = OverloadGenericVsConcrete() // $ target=init()
  let r1 = o.process(42) // $ type=r1:String target=OverloadGenericVsConcrete.process(_:Int)
  let r2 = o.process("hello") // $ type=r2:String target=OverloadGenericVsConcrete.process<T>(_:)
  let r3 = o.process(true) // $ type=r3:String target=OverloadGenericVsConcrete.process<T>(_:)
}

// --- Overload: free functions by parameter type ---

// freeOverload(_:Int)
func freeOverload(_ x: Int) -> String {
  return "int"
}

// freeOverload(_:String)
func freeOverload(_ x: String) -> String {
  return "string"
}

// freeOverload(_:Double)
func freeOverload(_ x: Double) -> String {
  return "double"
}

func testFreeOverload() {
  let r1 = freeOverload(42) // $ type=r1:String target=freeOverload(_:Int)
  let r2 = freeOverload("hi") // $ type=r2:String target=freeOverload(_:String)
  let r3 = freeOverload(1.5) // $ type=r3:String target=freeOverload(_:Double)
}

// --- Overload: init overloading ---

class MultiInit {
  var value : String

  // MultiInit.init()
  init() {
    value = "default"
  }

  // MultiInit.init(int:)
  init(int: Int) {
    value = "int"
  }

  // MultiInit.init(str:)
  init(str: String) {
    value = str // $ type=str:String
  }

  // MultiInit.init(x:y:)
  init(x: Int, y: Int) {
    value = "pair"
  }

  // MultiInit.getValue
  func getValue() -> String {
    return value // $ type=.value:String
  }
}

func testInitOverloading() {
  let m1 = MultiInit() // $ type=m1:MultiInit target=MultiInit.init()
  let m2 = MultiInit(int: 5) // $ type=m2:MultiInit target=MultiInit.init(int:)
  let m3 = MultiInit(str: "x") // $ type=m3:MultiInit target=MultiInit.init(str:)
  let m4 = MultiInit(x: 1, y: 2) // $ type=m4:MultiInit target=MultiInit.init(x:y:)
  let v = m1.getValue() // $ type=v:String target=MultiInit.getValue
}

// --- Overload: static vs instance method ---

class StaticVsInstance {
  // StaticVsInstance.action()->instance
  func action() -> String {
    return "instance"
  }

  // StaticVsInstance.action()->static
  static func action() -> String {
    return "static"
  }

  // StaticVsInstance.init
  init() {}
}

func testStaticVsInstance() {
  let o = StaticVsInstance() // $ target=StaticVsInstance.init
  let r1 = o.action() // $ type=r1:String target=StaticVsInstance.action()->instance
  let r2 = StaticVsInstance.action() // $ type=r2:String target=StaticVsInstance.action()->static
}

// --- Overload: protocol extension default vs concrete implementation ---

protocol Describable {
  // Describable.describe
  func describe() -> String
}

extension Describable {
  // Describable.describe(default)
  func describe() -> String {
    return "default"
  }

  // Describable.extra
  func extra() -> String {
    return "extra"
  }
}

class DescribableImpl : Describable {
  // DescribableImpl.init
  init() {}

  // DescribableImpl.describe
  func describe() -> String {
    return "concrete"
  }
}

func testProtocolExtensionOverload() {
  let d = DescribableImpl() // $ target=DescribableImpl.init
  let r1 = d.describe() // $ type=r1:String target=DescribableImpl.describe
  let r2 = d.extra() // $ type=r2:String target=Describable.extra
}

// --- Overload: subclass override resolution ---

class Base {
  // Base.init
  init() {}

  // Base.action
  func action() -> String {
    return "base"
  }

  // Base.baseOnly
  func baseOnly() -> String {
    return "baseOnly"
  }
}

class Sub : Base {
  // Sub.init
  override init() {
    super.init() // $ target=Base.init
  }

  // Sub.action
  override func action() -> String {
    return "sub"
  }

  // Sub.subOnly
  func subOnly() -> String {
    return "subOnly"
  }
}

class SubSub : Sub {
  // SubSub.init
  override init() {
    super.init() // $ target=Sub.init
  }

  // SubSub.action
  override func action() -> String {
    return "subsub"
  }
}

func testOverrideResolution() {
  let b = Base() // $ target=Base.init
  let rb = b.action() // $ type=rb:String target=Base.action

  let s = Sub() // $ target=Sub.init
  let rs = s.action() // $ type=rs:String target=Sub.action
  let rbo = s.baseOnly() // $ type=rbo:String target=Base.baseOnly
  let rso = s.subOnly() // $ type=rso:String target=Sub.subOnly

  let ss = SubSub() // $ target=SubSub.init
  let rss = ss.action() // $ type=rss:String target=SubSub.action
  let rbo2 = ss.baseOnly() // $ type=rbo2:String target=Base.baseOnly
  let rso2 = ss.subOnly() // $ type=rso2:String target=Sub.subOnly
}

// --- Overload: by external vs internal parameter names ---

class LabelVariants {
  // LabelVariants.send(to:)
  func send(to target: String) -> String {
    return target // $ type=target:String
  }

  // LabelVariants.send(from:)
  func send(from source: String) -> String {
    return source // $ type=source:String
  }

  // LabelVariants.send(to:from:)
  func send(to target: String, from source: String) -> String {
    return target + source
  }
}

func testLabelVariants() {
  let o = LabelVariants() // $ target=init()
  let r1 = o.send(to: "x") // $ type=r1:String target=LabelVariants.send(to:)
  let r2 = o.send(from: "y") // $ type=r2:String target=LabelVariants.send(from:)
  let r3 = o.send(to: "x", from: "y") // $ type=r3:String target=LabelVariants.send(to:from:)
}

// --- Overload: generic function with different constraint satisfaction ---

protocol Numeric2 : Equatable {
  // Numeric2.zero
  static func zero() -> Self
}

extension Int : Numeric2 {
  // Int.zero
  static func zero() -> Int { return 0 }
}

extension Double : Numeric2 {
  // Double.zero
  static func zero() -> Double { return 0.0 }
}

// constrainedId(_:Numeric2)
func constrainedId<T: Numeric2>(_ x: T) -> T {
  return x
}

// constrainedId(_:Equatable)
func constrainedId<T: Equatable>(_ x: T) -> T {
  return x
}

func testConstrainedOverload() {
  let r1 = constrainedId(42) // $ type=r1:Int target=constrainedId(_:Numeric2)
  let r2 = constrainedId("hello") // $ type=r2:String target=constrainedId(_:Equatable)
}

// --- Overload: methods on generic type specialized differently ---

class Box<T> {
  var item : T

  // Box.init
  init(_ item: T) {
    self.item = item // $ type=item:T
  }

  // Box.get
  func get() -> T {
    return item // $ type=.item:T
  }

  // Box.replace
  func replace(_ newItem: T) {
    item = newItem // $ type=newItem:T
  }
}

func testGenericMethodResolution() {
  let intBox = Box(10) // $ type=intBox@Box<T>:Int target=Box.init
  let strBox = Box("hi") // $ type=strBox@Box<T>:String target=Box.init
  let v1 = intBox.get() // $ type=v1:Int target=Box.get
  let v2 = strBox.get() // $ type=v2:String target=Box.get
  intBox.replace(20) // $ target=Box.replace
  strBox.replace("bye") // $ target=Box.replace
}

// --- Overload: convenience init vs designated init ---

class Widget {
  var name : String
  var size : Int

  // Widget.init(name:size:)
  init(name: String, size: Int) {
    self.name = name // $ type=name:String
    self.size = size // $ type=size:Int
  }

  // Widget.init(name:)
  convenience init(name: String) {
    self.init(name: name, size: 1) // $ target=Widget.init(name:size:)
  }

  // Widget.init(size:)
  convenience init(size: Int) {
    self.init(name: "default", size: size) // $ target=Widget.init(name:size:)
  }
}

func testConvenienceInit() {
  let w1 = Widget(name: "a", size: 5) // $ type=w1:Widget target=Widget.init(name:size:)
  let w2 = Widget(name: "b") // $ type=w2:Widget target=Widget.init(name:)
  let w3 = Widget(size: 10) // $ type=w3:Widget target=Widget.init(size:)
}

// --- Overload: methods with closure parameters of different signatures ---

class Processor {
  // Processor.init
  init() {}

  // Processor.apply(_:(Int)->Int)
  func apply(_ f: (Int) -> Int) -> Int {
    return f(0)
  }

  // Processor.apply(_:(String)->String)
  func apply(_ f: (String) -> String) -> String {
    return f("")
  }

  // Processor.apply(_:(Int,Int)->Int)
  func apply(_ f: (Int, Int) -> Int) -> Int {
    return f(0, 0)
  }
}

func testClosureOverload() {
  let p = Processor() // $ target=Processor.init
  let r1 = p.apply({ x in x + 1 }) // $ type=r1:Int target=Processor.apply(_:(Int)->Int)
  let r2 = p.apply({ s in s + "!" }) // $ type=r2:String target=Processor.apply(_:(String)->String)
  let r3 = p.apply({ x, y in x + y }) // $ type=r3:Int target=Processor.apply(_:(Int,Int)->Int)
}

// --- Overload: subscript-like method overloading ---

class MultiSubscript {
  var data : [Int] = [1, 2, 3]
  var dict : [String: Int] = ["a": 1]

  // MultiSubscript.init
  init() {}

  // MultiSubscript.get(_:)
  func get(_ index: Int) -> Int {
    return data[index]
  }

  // MultiSubscript.get(_:String)
  func get(_ key: String) -> Int {
    return dict[key] ?? 0
  }
}

func testMethodSubscriptLike() {
  let ms = MultiSubscript() // $ target=MultiSubscript.init
  let r1 = ms.get(0) // $ type=r1:Int target=MultiSubscript.get(_:)
  let r2 = ms.get("a") // $ type=r2:Int target=MultiSubscript.get(_:String)
}
