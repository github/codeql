// --- Static methods ---

class MathUtils {
  static func square(x: Int) -> Int {
    return x * x  // $ type=x:Int
  }

  class func cube(x: Int) -> Int {
    return x * x * x  // $ type=x:Int
  }
}

func testStaticMethods() {
  let s = MathUtils.square(x: 4)  // $ type=s:Int target=MathUtils.square
  let cu = MathUtils.cube(x: 3)  // $ type=cu:Int target=MathUtils.cube
}

// --- Simple overloading ---

class Overloaded {
  func process(_ x: Int) -> Int {  // name=process1
    return x + 1  // $ type=x:Int
  }

  func process(_ s: String) -> String {  // name=process2
    return s  // $ type=s:String
  }
}

func testOverloading() {
  let o = Overloaded()  // $ MISSING: target=Overloaded.init
  let r1 = o.process(42)  // $ MISSING: type=r1:Int target=Overloaded.process1
  let r2 = o.process("hello")  // $ MISSING: type=r2:String target=Overloaded.process2
}

// --- Structs and methods ---

struct Matrix {
  var data: [[Int]]

  init(data: [[Int]]) {
    self.data = data  // $ field=Matrix.data
  }

  func rowCount() -> Int {
    return data.count  // $ field=Matrix.data
  }
}

func testSubscripts() {
  let m = Matrix(data: [[1, 2], [3, 4]])  // $ target=Matrix.init
  let rc = m.rowCount()  // $ type=rc:Int target=Matrix.rowCount
}

// --- Nested types ---

class Outer {
  class Inner {
    var value: Int

    init(value: Int) {
      self.value = value  // $ type=value:Int field=Outer.Inner.value
    }

    func getValue() -> Int {
      return self.value  // $ type=.value:Int field=Outer.Inner.value
    }
  }
}

func testNestedTypes() {
  let inner = Outer.Inner(value: 99)  // $ type=inner:Inner target=Outer.Inner.init
  let v = inner.getValue()  // $ type=v:Int target=Outer.Inner.getValue
}

// --- Method chaining ---

class Builder {
  var value: Int = 0

  init() {}

  func set(_ v: Int) -> Builder {
    value = v  // $ type=v:Int field=Builder.value
    return self
  }

  func add(_ v: Int) -> Builder {
    value += v  // $ type=v:Int field=Builder.value
    return self
  }

  func build() -> Int {
    return value  // $ type=value:Int field=Builder.value
  }
}

func testChaining() {
  let b = Builder()  // $ type=b:Builder target=Builder.init
  let result = b.set(10).add(5).build()  // $ type=result:Int target=Builder.set target=Builder.add target=Builder.build
}

// --- Default parameter values ---

class Config {
  init() {}

  func setup(retries: Int = 3, timeout: Double = 30.0) -> Int {
    return retries  // $ type=retries:Int
  }
}

func testDefaultParams() {
  let cfg = Config()  // $ type=cfg:Config target=Config.init
  let r1 = cfg.setup()  // $ type=r1:Int target=Config.setup
  let r2 = cfg.setup(retries: 5)  // $ type=r2:Int target=Config.setup
  let r3 = cfg.setup(retries: 2, timeout: 60.0)  // $ type=r3:Int target=Config.setup
}

// --- Computed properties accessed via methods ---

class Temperature {
  var celsius: Double

  init(celsius: Double) {
    self.celsius = celsius  // $ type=celsius:Double field=Temperature.celsius
  }

  func toCelsius() -> Double {
    return celsius  // $ type=celsius:Double field=Temperature.celsius
  }

  func toFahrenheit() -> Double {
    return celsius * 9.0 / 5.0 + 32.0  // $ type=celsius:Double field=Temperature.celsius
  }
}

func testTemperature() {
  let t = Temperature(celsius: 100.0)  // $ type=t:Temperature target=Temperature.init
  let c = t.toCelsius()  // $ type=c:Double target=Temperature.toCelsius
  let f = t.toFahrenheit()  // $ type=f:Double target=Temperature.toFahrenheit
}

// --- Inheritance with overriding ---

class Animal {
  init() {}

  func speak() -> String {
    return "..."
  }
}

class Dog: Animal {
  override init() {
    super.init()  // $ target=Animal.init
  }

  override func speak() -> String {
    return "Woof"
  }

  func fetch() -> String {
    return "ball"
  }
}

class Cat: Animal {
  override init() {
    super.init()  // $ target=Animal.init
  }

  override func speak() -> String {
    return "Meow"
  }
}

func testOverriding() {
  let d = Dog()  // $ type=d:Dog target=Dog.init
  let ds = d.speak()  // $ type=ds:String target=Dog.speak
  let df = d.fetch()  // $ type=df:String target=Dog.fetch

  let ct = Cat()  // $ type=ct:Cat target=Cat.init
  let cs = ct.speak()  // $ type=cs:String target=Cat.speak
}

// --- Mutating methods on structs ---

struct Counter {
  var count: Int = 0

  mutating func increment() {
    count += 1  // $ type=count:Int field=Counter.count
  }

  func getCount() -> Int {
    return count  // $ type=count:Int field=Counter.count
  }
}

func testMutating() {
  var ctr = Counter()  // $ MISSING: type=ctr:Counter target=init()
  ctr.increment()  // $ MISSING: target=Counter.increment
  let val = ctr.getCount()  // $ MISSING: type=val:Int target=Counter.getCount
}
