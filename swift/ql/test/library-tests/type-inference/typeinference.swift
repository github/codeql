var topLevelDecl : Int = 0
0
topLevelDecl + 1 // $ type=topLevelDecl:Int

class C {
  var myInt : Int
  // C.init
  init(n: Int) {
    myInt = n // $ type=n:Int
  }

  // C.getMyInt
  func getMyInt() -> Int {
    return myInt // $ type=.myInt:Int
  }
}

class Derived : C {
  // Derived.init
  init() {
    super.init(n: 0) // $ type=super:C target=C.init
  }

  // Derived.callGetMyInt
  func callGetMyInt() -> Int {
    let x = getMyInt(); // $ type=x:Int target=C.getMyInt
    return x
  }
}

class Generic<T> {
  var value : T
  // Generic.init
  init(v: T) {
    value = v // $ type=v:T
  }

  // Generic.getValue
  func getValue() -> T {
    return value // $ type=.value:T
  }
}

class GenericDerived : Generic<Int> {
  // GenericDerived.init
  init() {
    super.init(v: 0) // $ type=super@Generic<T>:Int target=Generic.init
  }
}

func testGeneric() {
  let g = Generic(v: 42) // $ type=g@Generic<T>:Int target=Generic.init
  let x = g.getValue() // $ type=x:Int target=Generic.getValue

  let gd = GenericDerived() // $ type=gd:GenericDerived target=GenericDerived.init
  let y = gd.getValue() // $ type=y:Int target=Generic.getValue
}

// --- Protocols and protocol conformance ---

protocol Shape {
  // Shape.area
  func area() -> Double
}

struct Circle : Shape {
  var radius : Double

  // Circle.init
  init(radius: Double) {
    self.radius = radius // $ type=radius:Double
  }

  // Circle.area
  func area() -> Double {
    return 3.14159 * radius * radius // $ type=.radius:Double
  }
}

struct Rectangle : Shape {
  var width : Double
  var height : Double

  // Rectangle.init
  init(width: Double, height: Double) {
    self.width = width // $ type=width:Double
    self.height = height // $ type=height:Double
  }

  // Rectangle.area
  func area() -> Double {
    return width * height // $ type=.width:Double
  }
}

func testProtocol() {
  let c = Circle(radius: 5.0) // $ type=c:Circle target=Circle.init
  let a1 = c.area() // $ type=a1:Double target=Circle.area

  let r = Rectangle(width: 3.0, height: 4.0) // $ type=r:Rectangle target=Rectangle.init
  let a2 = r.area() // $ type=a2:Double target=Rectangle.area
}

// --- Extensions ---

extension C {
  // C.doubled
  func doubled() -> Int {
    return myInt * 2 // $ type=.myInt:Int
  }
}

func testExtension() {
  let obj = C(n: 10) // $ target=C.init
  let d = obj.doubled() // $ type=d:Int target=C.doubled
}

// --- Static methods ---

class MathUtils {
  // MathUtils.square
  static func square(x: Int) -> Int {
    return x * x // $ type=x:Int
  }

  // MathUtils.cube
  class func cube(x: Int) -> Int {
    return x * x * x // $ type=x:Int
  }
}

func testStaticMethods() {
  let s = MathUtils.square(x: 4) // $ type=s:Int target=MathUtils.square
  let cu = MathUtils.cube(x: 3) // $ type=cu:Int target=MathUtils.cube
}

// --- Overloading ---

class Overloaded {
  // Overloaded.process(_:Int)
  func process(_ x: Int) -> Int {
    return x + 1 // $ type=x:Int
  }

  // Overloaded.process(_:String)
  func process(_ s: String) -> String {
    return s // $ type=s:String
  }
}

func testOverloading() {
  let o = Overloaded() // $ target=init()
  let r1 = o.process(42) // $ type=r1:Int target=Overloaded.process(_:Int)
  let r2 = o.process("hello") // $ type=r2:String target=Overloaded.process(_:String)
}

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

// --- Generic constraints ---

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

// --- Subscripts ---

struct Matrix {
  var data : [[Int]]

  // Matrix.init
  init(data: [[Int]]) {
    self.data = data
  }

  // Matrix.rowCount
  func rowCount() -> Int {
    return data.count
  }
}

func testSubscripts() {
  let m = Matrix(data: [[1, 2], [3, 4]]) // $ target=Matrix.init
  let rc = m.rowCount() // $ type=rc:Int target=Matrix.rowCount
}

// --- Nested types ---

class Outer {
  class Inner {
    var value : Int

    // Outer.Inner.init
    init(value: Int) {
      self.value = value // $ type=value:Int
    }

    // Outer.Inner.getValue
    func getValue() -> Int {
      return self.value // $ type=.value:Int
    }
  }
}

func testNestedTypes() {
  let inner = Outer.Inner(value: 99) // $ type=inner:Inner target=Outer.Inner.init
  let v = inner.getValue() // $ type=v:Int target=Outer.Inner.getValue
}

// --- Method chaining ---

class Builder {
  var value : Int = 0

  // Builder.init
  init() {}

  // Builder.set
  func set(_ v: Int) -> Builder {
    value = v
    return self
  }

  // Builder.add
  func add(_ v: Int) -> Builder {
    value += v
    return self
  }

  // Builder.build
  func build() -> Int {
    return value // $ type=.value:Int
  }
}

func testChaining() {
  let b = Builder() // $ type=b:Builder target=Builder.init
  let result = b.set(10).add(5).build() // $ type=result:Int target=Builder.set target=Builder.add target=Builder.build
}

// --- Protocol with associated type-like patterns (using generics) ---

protocol Container {
  associatedtype Item
  // Container.getItem
  func getItem() -> Item
  // Container.count
  func count() -> Int
}

struct IntContainer : Container {
  typealias Item = Int
  var items : [Int]

  // IntContainer.init
  init(items: [Int]) {
    self.items = items
  }

  // IntContainer.getItem
  func getItem() -> Int {
    return items[0]
  }

  // IntContainer.count
  func count() -> Int {
    return items.count
  }
}

func testAssociatedTypes() {
  let ic = IntContainer(items: [1, 2, 3]) // $ type=ic:IntContainer target=IntContainer.init
  let item = ic.getItem() // $ type=item:Int target=IntContainer.getItem
  let cnt = ic.count() // $ type=cnt:Int target=IntContainer.count
}

// --- Default parameter values ---

class Config {
  // Config.init
  init() {}

  // Config.setup
  func setup(retries: Int = 3, timeout: Double = 30.0) -> Int {
    return retries // $ type=retries:Int
  }
}

func testDefaultParams() {
  let cfg = Config() // $ type=cfg:Config target=Config.init
  let r1 = cfg.setup() // $ type=r1:Int target=Config.setup
  let r2 = cfg.setup(retries: 5) // $ type=r2:Int target=Config.setup
  let r3 = cfg.setup(retries: 2, timeout: 60.0) // $ type=r3:Int target=Config.setup
}

// --- Multiple inheritance (protocol conformance) ---

protocol Printable {
  // Printable.display
  func display() -> String
}

protocol Identifiable {
  // Identifiable.id
  func id() -> Int
}

class Entity : Printable, Identifiable {
  var name : String
  var entityId : Int

  // Entity.init
  init(name: String, entityId: Int) {
    self.name = name // $ type=name:String
    self.entityId = entityId // $ type=entityId:Int
  }

  // Entity.display
  func display() -> String {
    return name // $ type=.name:String
  }

  // Entity.id
  func id() -> Int {
    return entityId // $ type=.entityId:Int
  }
}

func testMultipleProtocols() {
  let e = Entity(name: "test", entityId: 42) // $ type=e:Entity target=Entity.init
  let d = e.display() // $ type=d:String target=Entity.display
  let eid = e.id() // $ type=eid:Int target=Entity.id
}

// --- Computed properties accessed via methods ---

class Temperature {
  var celsius : Double

  // Temperature.init
  init(celsius: Double) {
    self.celsius = celsius // $ type=celsius:Double
  }

  // Temperature.toCelsius
  func toCelsius() -> Double {
    return celsius // $ type=.celsius:Double
  }

  // Temperature.toFahrenheit
  func toFahrenheit() -> Double {
    return celsius * 9.0 / 5.0 + 32.0 // $ type=.celsius:Double
  }
}

func testTemperature() {
  let t = Temperature(celsius: 100.0) // $ type=t:Temperature target=Temperature.init
  let c = t.toCelsius() // $ type=c:Double target=Temperature.toCelsius
  let f = t.toFahrenheit() // $ type=f:Double target=Temperature.toFahrenheit
}

// --- Inheritance with overriding ---

class Animal {
  // Animal.init
  init() {}

  // Animal.speak
  func speak() -> String {
    return "..."
  }
}

class Dog : Animal {
  // Dog.init
  override init() {
    super.init() // $ target=Animal.init
  }

  // Dog.speak
  override func speak() -> String {
    return "Woof"
  }

  // Dog.fetch
  func fetch() -> String {
    return "ball"
  }
}

class Cat : Animal {
  // Cat.init
  override init() {
    super.init() // $ target=Animal.init
  }

  // Cat.speak
  override func speak() -> String {
    return "Meow"
  }
}

func testOverriding() {
  let d = Dog() // $ type=d:Dog target=Dog.init
  let ds = d.speak() // $ type=ds:String target=Dog.speak
  let df = d.fetch() // $ type=df:String target=Dog.fetch

  let ct = Cat() // $ type=ct:Cat target=Cat.init
  let cs = ct.speak() // $ type=cs:String target=Cat.speak
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

// --- Mutating methods on structs ---

struct Counter {
  var count : Int = 0

  // Counter.increment
  mutating func increment() {
    count += 1
  }

  // Counter.getCount
  func getCount() -> Int {
    return count // $ type=.count:Int
  }
}

func testMutating() {
  var ctr = Counter() // $ type=ctr:Counter target=init()
  ctr.increment() // $ target=Counter.increment
  let val = ctr.getCount() // $ type=val:Int target=Counter.getCount
}

// ============================================================
// Overload resolution tests
// ============================================================

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

// --- Overload: subscript overloading ---

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

// ============================================================
// Type parameters with constraints
// ============================================================

// --- where clause on generic function ---

// minOf(_:_:)
func minOf<T: Comparable>(_ a: T, _ b: T) -> T {
  if a < b { return a } else { return b }
}

// maxOf(_:_:)
func maxOf<T>(_ a: T, _ b: T) -> T where T : Comparable {
  if a > b { return a } else { return b }
}

func testWhereClause() {
  let m1 = minOf(3, 7) // $ type=m1:Int target=minOf(_:_:)
  let m2 = minOf("a", "z") // $ type=m2:String target=minOf(_:_:)
  let m3 = maxOf(3, 7) // $ type=m3:Int target=maxOf(_:_:)
  let m4 = maxOf("a", "z") // $ type=m4:String target=maxOf(_:_:)
}

// --- Multiple constraints on a single type parameter ---

protocol Displayable2 {
  // Displayable2.display
  func display() -> String
}

protocol Sortable {
  // Sortable.sortKey
  func sortKey() -> Int
}

struct TaggedItem : Displayable2, Sortable, Equatable {
  var tag : String
  var priority : Int

  // TaggedItem.init
  init(tag: String, priority: Int) {
    self.tag = tag // $ type=tag:String
    self.priority = priority // $ type=priority:Int
  }

  // TaggedItem.display
  func display() -> String {
    return tag // $ type=.tag:String
  }

  // TaggedItem.sortKey
  func sortKey() -> Int {
    return priority // $ type=.priority:Int
  }
}

// showAndSort(_:)
func showAndSort<T: Displayable2 & Sortable>(_ item: T) -> String {
  return item.display() // $ target=Displayable2.display
}

// showSortAndCompare(_:_:)
func showSortAndCompare<T>(_ a: T, _ b: T) -> Bool where T : Displayable2, T : Sortable, T : Equatable {
  return a == b
}

func testMultipleConstraints() {
  let item = TaggedItem(tag: "x", priority: 1) // $ target=TaggedItem.init
  let s = showAndSort(item) // $ type=s:String target=showAndSort(_:)
  let eq = showSortAndCompare(item, item) // $ type=eq:Bool target=showSortAndCompare(_:_:)
}

// --- Generic class with multiple constrained type parameters ---

class SortedPair<T: Comparable, U: Comparable> {
  var first : T
  var second : U

  // SortedPair.init
  init(first: T, second: U) {
    self.first = first // $ type=first:T
    self.second = second // $ type=second:U
  }

  // SortedPair.isFirstSmaller
  func isFirstSmaller(than other: T) -> Bool {
    return first < other // $ type=other:T
  }

  // SortedPair.isSecondSmaller
  func isSecondSmaller(than other: U) -> Bool {
    return second < other // $ type=other:U
  }
}

func testMultiConstrainedParams() {
  let sp = SortedPair(first: 3, second: "b") // $ target=SortedPair.init
  let r1 = sp.isFirstSmaller(than: 5) // $ type=r1:Bool target=SortedPair.isFirstSmaller
  let r2 = sp.isSecondSmaller(than: "z") // $ type=r2:Bool target=SortedPair.isSecondSmaller
}

// --- Associated type constraints (same-type constraint) ---

protocol ElementContainer {
  associatedtype Element
  // ElementContainer.first
  func first() -> Element
}

struct IntArray : ElementContainer {
  typealias Element = Int
  var items : [Int]

  // IntArray.init
  init(items: [Int]) {
    self.items = items
  }

  // IntArray.first
  func first() -> Int {
    return items[0]
  }
}

struct StringArray : ElementContainer {
  typealias Element = String
  var items : [String]

  // StringArray.init
  init(items: [String]) {
    self.items = items
  }

  // StringArray.first
  func first() -> String {
    return items[0]
  }
}

// extractFirst(from:Int)
func extractFirst<C: ElementContainer>(from container: C) -> C.Element where C.Element == Int {
  return container.first() // $ target=ElementContainer.first
}

// extractFirst(from:String)
func extractFirst<C: ElementContainer>(from container: C) -> C.Element where C.Element == String {
  return container.first() // $ target=ElementContainer.first
}

func testSameTypeConstraint() {
  let ia = IntArray(items: [10, 20]) // $ target=IntArray.init
  let sa = StringArray(items: ["hi", "there"]) // $ target=StringArray.init
  let r1 = extractFirst(from: ia) // $ type=r1:Int target=extractFirst(from:Int)
  let r2 = extractFirst(from: sa) // $ type=r2:String target=extractFirst(from:String)
}

// --- Superclass constraint on type parameter ---

class Vehicle {
  var speed : Int

  // Vehicle.init
  init(speed: Int) {
    self.speed = speed // $ type=speed:Int
  }

  // Vehicle.describe
  func describe() -> String {
    return "vehicle"
  }
}

class Car : Vehicle {
  // Car.init
  override init(speed: Int) {
    super.init(speed: speed) // $ target=Vehicle.init
  }

  // Car.describe
  override func describe() -> String {
    return "car"
  }

  // Car.honk
  func honk() -> String {
    return "beep"
  }
}

class Truck : Vehicle {
  // Truck.init
  override init(speed: Int) {
    super.init(speed: speed) // $ target=Vehicle.init
  }

  // Truck.describe
  override func describe() -> String {
    return "truck"
  }

  // Truck.haul
  func haul() -> String {
    return "hauling"
  }
}

// describeVehicle(_:)
func describeVehicle<T: Vehicle>(_ v: T) -> String {
  return v.describe() // $ target=Vehicle.describe
}

func testSuperclassConstraint() {
  let car = Car(speed: 100) // $ type=car:Car target=Car.init
  let truck = Truck(speed: 60) // $ type=truck:Truck target=Truck.init
  let d1 = describeVehicle(car) // $ type=d1:String target=describeVehicle(_:)
  let d2 = describeVehicle(truck) // $ type=d2:String target=describeVehicle(_:)
  let h = car.honk() // $ type=h:String target=Car.honk
  let hl = truck.haul() // $ type=hl:String target=Truck.haul
}

// --- Constrained extension methods ---

protocol Summable {
  // Summable.+
  static func +(lhs: Self, rhs: Self) -> Self
}

extension Int : Summable {}
extension Double : Summable {}
extension String : Summable {}

struct Accumulator<T> {
  var values : [T]

  // Accumulator.init
  init(values: [T]) {
    self.values = values
  }

  // Accumulator.count
  func count() -> Int {
    return values.count
  }
}

extension Accumulator where T : Summable {
  // Accumulator.total
  func total() -> T {
    return values[0] + values[1] // $ target=Summable.+
  }
}

extension Accumulator where T : Equatable {
  // Accumulator.contains
  func contains(_ item: T) -> Bool {
    return values.contains(where: { $0 == item })
  }
}

func testConstrainedExtensions() {
  let intAcc = Accumulator(values: [1, 2, 3]) // $ target=Accumulator.init
  let cnt = intAcc.count() // $ type=cnt:Int target=Accumulator.count
  let tot = intAcc.total() // $ type=tot:Int target=Accumulator.total
  let has = intAcc.contains(2) // $ type=has:Bool target=Accumulator.contains
}

// --- Generic method with its own constrained type parameter ---

class Transformer {
  // Transformer.init
  init() {}

  // Transformer.transform
  func transform<T: Summable>(_ items: [T]) -> T {
    return items[0] + items[1] // $ target=Summable.+
  }

  // Transformer.merge
  func merge<A: Equatable, B: Equatable>(_ a: A, _ b: B) -> Bool {
    return true
  }
}

func testMethodTypeParams() {
  let t = Transformer() // $ target=Transformer.init
  let r1 = t.transform([3, 1, 2]) // $ type=r1:Int target=Transformer.transform
  let r2 = t.transform(["c", "a", "b"]) // $ type=r2:String target=Transformer.transform
  let r3 = t.merge(1, "x") // $ type=r3:Bool target=Transformer.merge
}

// --- Recursive constraint (Comparable requiring Equatable) ---

// clamp(_:min:max:)
func clamp<T: Comparable>(_ value: T, min lower: T, max upper: T) -> T {
  if value < lower { return lower }
  if value > upper { return upper }
  return value
}

func testRecursiveConstraint() {
  let r1 = clamp(5, min: 0, max: 10) // $ type=r1:Int target=clamp(_:min:max:)
  let r2 = clamp(3.5, min: 1.0, max: 2.0) // $ type=r2:Double target=clamp(_:min:max:)
  let r3 = clamp("m", min: "a", max: "z") // $ type=r3:String target=clamp(_:min:max:)
}