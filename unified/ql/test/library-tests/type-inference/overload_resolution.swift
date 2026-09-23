// --- Overload by parameter type ---

class OverloadByType {
  public init() {}

  func handle(_ x: Int) -> String {  // name=OverloadByType.handle1
    return "int"
  }

  func handle(_ x: Double) -> String {  // name=OverloadByType.handle2
    return "double"
  }

  func handle(_ x: String) -> String {  // name=OverloadByType.handle3
    return "string"
  }

  func handle(_ x: Bool) -> String {  // name=OverloadByType.handle4
    return "bool"
  }
}

func testOverloadByType() {
  let o = OverloadByType()  // $ target=OverloadByType.init
  let r1 = o.handle(42)  // $ type=r1:String target=OverloadByType.handle1 $ SPURIOUS: target=OverloadByType.handle2 target=OverloadByType.handle3 target=OverloadByType.handle4
  let r2 = o.handle(3.14)  // $ type=r2:String target=OverloadByType.handle2 $ SPURIOUS: target=OverloadByType.handle1 target=OverloadByType.handle3 target=OverloadByType.handle4
  let r3 = o.handle("hi")  // $ type=r3:String target=OverloadByType.handle3 $ SPURIOUS: target=OverloadByType.handle1 target=OverloadByType.handle2 target=OverloadByType.handle4
  let r4 = o.handle(true)  // $ type=r4:String target=OverloadByType.handle4 $ SPURIOUS: target=OverloadByType.handle1 target=OverloadByType.handle2 target=OverloadByType.handle3
}

// --- Overload by argument label ---

class OverloadByLabel {
  public init() {}

  func configure(width: Int) -> String {  // name=OverloadByLabel.configure1
    return "width"
  }

  func configure(height: Int) -> String {  // name=OverloadByLabel.configure2
    return "height"
  }

  func configure(width: Int, height: Int) -> String {  // name=OverloadByLabel.configure3
    return "both"
  }

  func configure(size: Int) -> String {  // name=OverloadByLabel.configure4
    return "size"
  }
}

func testOverloadByLabel() {
  let o = OverloadByLabel()  // $ target=OverloadByLabel.init
  let r1 = o.configure(width: 10)  // $ type=r1:String target=OverloadByLabel.configure1 $ SPURIOUS: target=OverloadByLabel.configure2 target=OverloadByLabel.configure3 target=OverloadByLabel.configure4
  let r2 = o.configure(height: 20)  // $ type=r2:String target=OverloadByLabel.configure2 $ SPURIOUS: target=OverloadByLabel.configure1 target=OverloadByLabel.configure3 target=OverloadByLabel.configure4
  let r3 = o.configure(width: 10, height: 20)  // $ type=r3:String target=OverloadByLabel.configure3 $ SPURIOUS: target=OverloadByLabel.configure1 target=OverloadByLabel.configure2 target=OverloadByLabel.configure4
  let r4 = o.configure(size: 30)  // $ type=r4:String target=OverloadByLabel.configure4 $ SPURIOUS: target=OverloadByLabel.configure1 target=OverloadByLabel.configure2 target=OverloadByLabel.configure3
}

// --- Overload by arity (number of parameters) ---

class OverloadByArity {
  public init() {}

  func compute() -> Int {  // name=OverloadByArity.compute1
    return 0
  }

  func compute(_ x: Int) -> Int {  // name=OverloadByArity.compute2
    return x
  }

  func compute(_ x: Int, _ y: Int) -> Int {  // name=OverloadByArity.compute3
    return x + y
  }

  func compute(_ x: Int, _ y: Int, _ z: Int) -> Int {  // name=OverloadByArity.compute4
    return x + y + z
  }
}

func testOverloadByArity() {
  let o = OverloadByArity()  // $ target=OverloadByArity.init
  let r0 = o.compute()  // $ type=r0:Int target=OverloadByArity.compute1 $ SPURIOUS: target=OverloadByArity.compute2 target=OverloadByArity.compute3 target=OverloadByArity.compute4
  let r1 = o.compute(1)  // $ type=r1:Int target=OverloadByArity.compute2 $ SPURIOUS: target=OverloadByArity.compute1 target=OverloadByArity.compute3 target=OverloadByArity.compute4
  let r2 = o.compute(1, 2)  // $ type=r2:Int target=OverloadByArity.compute3 $ SPURIOUS: target=OverloadByArity.compute1 target=OverloadByArity.compute2 target=OverloadByArity.compute4
  let r3 = o.compute(1, 2, 3)  // $ type=r3:Int target=OverloadByArity.compute4 $ SPURIOUS: target=OverloadByArity.compute1 target=OverloadByArity.compute2 target=OverloadByArity.compute3
}

// --- Overload by return type (contextual type) ---

class OverloadByReturn {
  public init() {}

  func create() -> Int {  // name=OverloadByReturn.create1
    return 0
  }

  func create() -> String {  // name=OverloadByReturn.create2
    return ""
  }

  func create() -> Double {  // name=OverloadByReturn.create3
    return 0.0
  }
}

func testOverloadByReturn() {
  let o = OverloadByReturn()  // $ target=OverloadByReturn.init
  let r1: Int = o.create()  // $ type=r1:Int target=OverloadByReturn.create1 $ SPURIOUS: target=OverloadByReturn.create2 target=OverloadByReturn.create3
  let r2: String = o.create()  // $ type=r2:String target=OverloadByReturn.create2 $ SPURIOUS: target=OverloadByReturn.create1 target=OverloadByReturn.create3
  let r3: Double = o.create()  // $ type=r3:Double target=OverloadByReturn.create3 $ SPURIOUS: target=OverloadByReturn.create1 target=OverloadByReturn.create2
}

// --- Overload: generic vs non-generic (non-generic preferred) ---

class OverloadGenericVsConcrete {
  public init() {}

  func process(_ x: Int) -> String {  // name=OverloadGenericVsConcrete.process1
    return "concrete"
  }

  func process<T>(_ x: T) -> String {  // name=OverloadGenericVsConcrete.process2
    return "generic"
  }
}

func testOverloadGenericVsConcrete() {
  let o = OverloadGenericVsConcrete()  // $ target=OverloadGenericVsConcrete.init
  let r1 = o.process(42)  // $ type=r1:String target=OverloadGenericVsConcrete.process1 $ SPURIOUS: target=OverloadGenericVsConcrete.process2
  let r2 = o.process("hello")  // $ type=r2:String target=OverloadGenericVsConcrete.process2 $ SPURIOUS: target=OverloadGenericVsConcrete.process1
  let r3 = o.process(true)  // $ type=r3:String target=OverloadGenericVsConcrete.process2 $ SPURIOUS: target=OverloadGenericVsConcrete.process1
}

// --- Overload: free functions by parameter type ---

func freeOverload(_ x: Int) -> String {  // name=freeOverload1
  return "int"
}

func freeOverload(_ x: String) -> String {  // name=freeOverload2
  return "string"
}

func freeOverload(_ x: Double) -> String {  // name=freeOverload3
  return "double"
}

func testFreeOverload() {
  let r1 = freeOverload(42)  // $ type=r1:String target=freeOverload1 $ SPURIOUS: target=freeOverload2 target=freeOverload3
  let r2 = freeOverload("hi")  // $ type=r2:String target=freeOverload2 $ SPURIOUS: target=freeOverload1 target=freeOverload3
  let r3 = freeOverload(1.5)  // $ type=r3:String target=freeOverload3 $ SPURIOUS: target=freeOverload1 target=freeOverload2
}

// --- Overload: init overloading ---

class MultiInit {
  var value: String

  init() {  // name=MultiInit.init1
    value = "default"  // $ field=MultiInit.value
  }

  init(int: Int) {  // name=MultiInit.init2
    value = "int"  // $ field=MultiInit.value
  }

  init(str: String) {  // name=MultiInit.init3
    value = str  // $ type=str:String $ field=MultiInit.value
  }

  init(x: Int, y: Int) {  // name=MultiInit.init4
    value = "pair"  // $ field=MultiInit.value
  }

  func getValue() -> String {
    return value  // $ type=value:String $ field=MultiInit.value
  }
}

func testInitOverloading() {
  let m1 = MultiInit()  // $ type=m1:MultiInit target=MultiInit.init1 $ SPURIOUS: target=MultiInit.init2 target=MultiInit.init3 target=MultiInit.init4
  let m2 = MultiInit(int: 5)  // $ type=m2:MultiInit target=MultiInit.init2 $ SPURIOUS: target=MultiInit.init1 target=MultiInit.init3 target=MultiInit.init4
  let m3 = MultiInit(str: "x")  // $ type=m3:MultiInit target=MultiInit.init3 $ SPURIOUS: target=MultiInit.init1 target=MultiInit.init2 target=MultiInit.init4
  let m4 = MultiInit(x: 1, y: 2)  // $ type=m4:MultiInit target=MultiInit.init4 $ SPURIOUS: target=MultiInit.init1 target=MultiInit.init2 target=MultiInit.init3
  let v = m1.getValue()  // $ type=v:String target=MultiInit.getValue
}

// --- Overload: static vs instance method ---

class StaticVsInstance {
  func action() -> String {  // name=StaticVsInstance.action1
    return "instance"
  }

  static func action() -> String {  // name=StaticVsInstance.action2
    return "static"
  }

  init() {}
}

func testStaticVsInstance() {
  let o = StaticVsInstance()  // $ target=StaticVsInstance.init
  let r1 = o.action()  // $ type=r1:String target=StaticVsInstance.action1
  let r2 = StaticVsInstance.action()  // $ type=r2:String target=StaticVsInstance.action2
}

// --- Overload: protocol extension default vs concrete implementation ---

protocol Describable {
  func describe() -> String  // name=Describable.describe
}

extension Describable {
  func describe() -> String {  // name=Describable.describe_default
    return "default"
  }

  func extra() -> String {
    return "extra"
  }
}

class DescribableImpl: Describable {
  init() {}  // name=DescribableImpl.init

  func describe() -> String {  // name=DescribableImpl.describe
    return "concrete"
  }
}

func testProtocolExtensionOverload() {
  let d = DescribableImpl()  // $ target=DescribableImpl.init
  let r1 = d.describe()  // $ type=r1:String target=DescribableImpl.describe
  let r2 = d.extra()  // $ type=r2:String target=Describable.extra
}

// --- Overload: subclass override resolution ---

class Base {
  init() {}

  func action() -> String {
    return "base"
  }

  func baseOnly() -> String {
    return "baseOnly"
  }
}

class Sub: Base {
  override init() {
    super.init()  // $ target=Base.init
  }

  override func action() -> String {
    return "sub"
  }

  func subOnly() -> String {
    return "subOnly"
  }
}

class SubSub: Sub {
  override init() {
    super.init()  // $ target=Sub.init
  }

  override func action() -> String {
    return "subsub"
  }
}

func testOverrideResolution() {
  let b = Base()  // $ target=Base.init
  let rb = b.action()  // $ type=rb:String target=Base.action

  let s = Sub()  // $ target=Sub.init
  let rs = s.action()  // $ type=rs:String target=Sub.action
  let rbo = s.baseOnly()  // $ type=rbo:String target=Base.baseOnly
  let rso = s.subOnly()  // $ type=rso:String target=Sub.subOnly

  let ss = SubSub()  // $ target=SubSub.init
  let rss = ss.action()  // $ type=rss:String target=SubSub.action
  let rbo2 = ss.baseOnly()  // $ type=rbo2:String target=Base.baseOnly
  let rso2 = ss.subOnly()  // $ type=rso2:String target=Sub.subOnly
}

// --- Overload: by external vs internal parameter names ---

class LabelVariants {
  public init() {}

  func send(to target: String) -> String {  // name=LabelVariants.send1
    return target  // $ type=target:String
  }

  func send(from source: String) -> String {  // name=LabelVariants.send2
    return source  // $ type=source:String
  }

  func send(to target: String, from source: String) -> String {  // name=LabelVariants.send3
    return target + source
  }
}

func testLabelVariants() {
  let o = LabelVariants()  // $ target=LabelVariants.init
  let r1 = o.send(to: "x")  // $ type=r1:String target=LabelVariants.send1 $ SPURIOUS: target=LabelVariants.send2 target=LabelVariants.send3
  let r2 = o.send(from: "y")  // $ type=r2:String target=LabelVariants.send2 $ SPURIOUS: target=LabelVariants.send1 target=LabelVariants.send3
  let r3 = o.send(to: "x", from: "y")  // $ type=r3:String target=LabelVariants.send3 $ SPURIOUS: target=LabelVariants.send1 target=LabelVariants.send2
}

// --- Overload: generic function with different constraint satisfaction ---

protocol Numeric2: Equatable {
  static func zero() -> Self
}

extension Int: Numeric2 {
  static func zero() -> Int { return 0 }
}

extension Double: Numeric2 {
  static func zero() -> Double { return 0.0 }
}

func constrainedId<T: Numeric2>(_ x: T) -> T {  // name=constrainedId1
  return x
}

func constrainedId<T: Equatable>(_ x: T) -> T {  // name=constrainedId2
  return x
}

func testConstrainedOverload() {
  let r1 = constrainedId(42)  // $ type=r1:Int target=constrainedId1 $ SPURIOUS: target=constrainedId2
  let r2 = constrainedId("hello")  // $ type=r2:String target=constrainedId2 $ SPURIOUS: target=constrainedId1
}

// --- Overload: methods on generic type specialized differently ---

class Box<T> {
  var item: T

  init(_ item: T) {
    self.item = item  // $ type=item:T field=Box.item
  }

  func get() -> T {
    return item  // $ type=item:T field=Box.item
  }

  func replace(_ newItem: T) {
    item = newItem  // $ type=newItem:T field=Box.item
  }
}

func testGenericMethodResolution() {
  let intBox = Box(10)  // $ type=intBox@Box<T>:Int target=Box.init
  let strBox = Box("hi")  // $ type=strBox@Box<T>:String target=Box.init
  let v1 = intBox.get()  // $ type=v1:Int target=Box.get
  let v2 = strBox.get()  // $ type=v2:String target=Box.get
  intBox.replace(20)  // $ target=Box.replace
  strBox.replace("bye")  // $ target=Box.replace
}

// --- Overload: convenience init vs designated init ---

class Widget {
  var name: String
  var size: Int

  init(name: String, size: Int) {  // name=Widget.init1
    self.name = name  // $ type=name:String field=Widget.name
    self.size = size  // $ type=size:Int field=Widget.size
  }

  convenience init(name: String) {  // name=Widget.init2
    self.init(name: name, size: 1)  // $ target=Widget.init1 $ SPURIOUS: target=Widget.init2 target=Widget.init3
  }

  convenience init(size: Int) {  // name=Widget.init3
    self.init(name: "default", size: size)  // $ target=Widget.init1 $ SPURIOUS: target=Widget.init2 target=Widget.init3
  }
}

func testConvenienceInit() {
  let w1 = Widget(name: "a", size: 5)  // $ type=w1:Widget target=Widget.init1 $ SPURIOUS: target=Widget.init2 target=Widget.init3
  let w2 = Widget(name: "b")  // $ type=w2:Widget target=Widget.init2 $ SPURIOUS: target=Widget.init1 target=Widget.init3
  let w3 = Widget(size: 10)  // $ type=w3:Widget target=Widget.init3 $ SPURIOUS: target=Widget.init1 target=Widget.init2
}

// --- Overload: methods with closure parameters of different signatures ---

class Processor {
  init() {}

  func apply(_ f: (Int) -> Int) -> Int {  // name=Processor.apply1
    return f(0)  // $ target=Function.invoke
  }

  func apply(_ f: (String) -> String) -> String {  // name=Processor.apply2
    return f("")  // $ target=Function.invoke
  }

  func apply(_ f: (Int, Int) -> Int) -> Int {  // name=Processor.apply3
    return f(0, 0)  // $ target=Function.invoke
  }
}

func testClosureOverload() {
  let p = Processor()  // $ target=Processor.init
  let r1 = p.apply({ x in x + 1 })  // $ type=r1:Int target=Processor.apply1 $ SPURIOUS: target=Processor.apply2 target=Processor.apply3
  let r2 = p.apply({ s in s + "!" })  // $ type=r2:String target=Processor.apply2 $ SPURIOUS: target=Processor.apply1 target=Processor.apply3
  let r3 = p.apply({ x, y in x + y })  // $ type=r3:Int target=Processor.apply3 $ SPURIOUS: target=Processor.apply1 target=Processor.apply2
}

// --- Overload: subscript-like method overloading ---

class MultiSubscript {
  var data: [Int] = [1, 2, 3]
  var dict: [String: Int] = ["a": 1]

  init() {}

  func get(_ index: Int) -> Int {  // name=MultiSubscript.get1
    return data[index]  // $ field=MultiSubscript.data
  }

  func get(_ key: String) -> Int {  // name=MultiSubscript.get2
    return dict[key] ?? 0  // $ field=MultiSubscript.dict
  }
}

func testMethodSubscriptLike() {
  let ms = MultiSubscript()  // $ target=MultiSubscript.init
  let r1 = ms.get(0)  // $ type=r1:Int target=MultiSubscript.get1 $ SPURIOUS: target=MultiSubscript.get2
  let r2 = ms.get("a")  // $ type=r2:Int target=MultiSubscript.get2 $ SPURIOUS: target=MultiSubscript.get1
}
