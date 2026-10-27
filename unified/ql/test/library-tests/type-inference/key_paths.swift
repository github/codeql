// --- Key-path expressions: basic property access ---

struct Point {
  var x: Double
  var y: Double

  init(x: Double, y: Double) {
    self.x = x  // $ type=x:Double field=Point.x
    self.y = y  // $ type=y:Double field=Point.y
  }

  func distanceFromOrigin() -> Double {
    return (x * x + y * y).squareRoot()  // $ field=Point.x field=Point.x field=Point.y field=Point.y
  }
}

struct Line {
  var start: Point
  var end: Point

  init(start: Point, end: Point) {
    self.start = start  // $ field=Line.start
    self.end = end  // $ field=Line.end
  }
}

func testBasicKeyPaths() {
  let kpX = \Point.x
  let kpY = \Point.y

  let p = Point(x: 3.0, y: 4.0)  // $ type=p:Point target=Point.init
  let xVal = p[keyPath: kpX]  // $ MISSING: type=xVal:Double
  let yVal = p[keyPath: kpY]  // $ MISSING: type=yVal:Double
}

// --- Key-path expressions: nested property access ---

func testNestedKeyPaths() {
  let kpStartX = \Line.start.x
  let kpEndY = \Line.end.y

  let s = Point(x: 0.0, y: 0.0)  // $ target=Point.init
  let e = Point(x: 1.0, y: 1.0)  // $ target=Point.init
  let line = Line(start: s, end: e)  // $ target=Line.init
  let startX = line[keyPath: kpStartX]  // $ MISSING: type=startX:Double
  let endY = line[keyPath: kpEndY]  // $ MISSING: type=endY:Double
}

// --- Key-path expressions: identity (\.self) ---

func testSelfKeyPath() {
  let kpSelf = \Int.self
  let val = 42[keyPath: kpSelf]  // $ MISSING: type=val:Int
}

// --- Key-path expressions: optional chaining ---

struct Person {
  var name: String
  var address: Address?

  init(name: String, address: Address?) {
    self.name = name  // $ type=name:String field=Person.name
    self.address = address  // $ field=Person.address
  }
}

struct Address {
  var city: String
  var zip: String

  init(city: String, zip: String) {
    self.city = city  // $ type=city:String field=Address.city
    self.zip = zip  // $ type=zip:String field=Address.zip
  }
}

func testOptionalChainingKeyPaths() {
  let kpCity = \Person.address?.city
  let addr = Address(city: "NYC", zip: "10001")  // $ target=Address.init
  let person = Person(name: "Alice", address: addr)  // $ target=Person.init

  let city = person[keyPath: kpCity]  // $ MISSING: type=city@Optional<Wrapped>:String
}

// --- Key-path expressions: used as function arguments ---

struct Employee {
  var name: String
  var salary: Int

  init(name: String, salary: Int) {
    self.name = name  // $ type=name:String field=Employee.name
    self.salary = salary  // $ type=salary:Int field=Employee.salary
  }
}

func extractField<T, V>(_ items: [T], keyPath: KeyPath<T, V>) -> [V] {
  return items.map { $0[keyPath: keyPath] }  // $ target=Array.map
}

func testKeyPathAsArgument() {
  let e1 = Employee(name: "Alice", salary: 100)  // $ target=Employee.init
  let e2 = Employee(name: "Bob", salary: 200)  // $ target=Employee.init
  let employees = [e1, e2]
  let names = extractField(employees, keyPath: \.name)  // $ target=extractField $ MISSING: target=extractField(_:keyPath:)
  let name = names[0]  // $ MISSING: type=name:String
  let salaries = extractField(employees, keyPath: \.salary)  // $ target=extractField $ MISSING: target=extractField(_:keyPath:)
  let salary = salaries[0]  // $ MISSING: type=salary:Int
}

// --- Key-path expressions: with generics ---

class KPContainer<T> {
  var item: T

  init(item: T) {
    self.item = item  // $ type=item:T field=KPContainer.item
  }
}

func testGenericKeyPaths() {
  let kp = \KPContainer<Int>.item
  let c = KPContainer(item: 42)  // $ target=KPContainer.init
  let v = c[keyPath: kp]  // $ MISSING: type=v:Int
}

// --- Key-path expressions: writable key paths and mutation ---

func testWritableKeyPaths() {
  var p = Point(x: 1.0, y: 2.0)  // $ type=p:Point target=Point.init
  let kpX = \Point.x
  p[keyPath: kpX] = 10.0
  let newX = p[keyPath: kpX]  // $ MISSING: type=newX:Double
}

// --- Key-path expressions: appending key paths ---

func testKeyPathAppending() {
  let kpStart = \Line.start
  let kpX = \Point.x
  let kpStartX = kpStart.appending(path: kpX)

  let s = Point(x: 5.0, y: 6.0)  // $ target=Point.init
  let e = Point(x: 7.0, y: 8.0)  // $ target=Point.init
  let line = Line(start: s, end: e)  // $ target=Line.init
  let val = line[keyPath: kpStartX]  // $ MISSING: type=val:Double
}

// --- Key-path expressions: shorthand in higher-order functions ---

func testKeyPathInMap() {
  let e1 = Employee(name: "Alice", salary: 100)  // $ target=Employee.init
  let e2 = Employee(name: "Bob", salary: 200)  // $ target=Employee.init
  let employees = [e1, e2]
  let names = employees.map(\.name)  // $ target=Array.map
  let name = names[0]  // $ MISSING: type=name:String
  let salaries = employees.map(\.salary)  // $ target=Array.map
  let salary = salaries[0]  // $ MISSING: type=salary:Int
}

// --- Key-path expressions: class hierarchy ---

class Shape2 {
  var color: String

  init(color: String) {
    self.color = color  // $ type=color:String field=Shape2.color
  }
}

class Circle2: Shape2 {
  var radius: Double

  init(color: String, radius: Double) {
    self.radius = radius  // $ type=radius:Double field=Circle2.radius
    super.init(color: color)  // $ target=Shape2.init
  }
}

func testInheritedKeyPaths() {
  let kpColor = \Circle2.color
  let kpRadius = \Circle2.radius

  let c = Circle2(color: "red", radius: 5.0)  // $ type=c:Circle2 target=Circle2.init
  let col = c[keyPath: kpColor]  // $ MISSING: type=col:String
  let rad = c[keyPath: kpRadius]  // $ MISSING: type=rad:Double
}

// --- Key-path expressions: tuple element access ---

func testTupleKeyPath() {
  let kp0 = \(Int, String).0
  let kp1 = \(Int, String).1
  let tuple = (42, "hello")
  let first = tuple[keyPath: kp0]  // $ MISSING: type=first:Int
  let second = tuple[keyPath: kp1]  // $ MISSING: type=second:String
}

// --- Key-path expressions: array/dictionary subscript ---

func testSubscriptKeyPaths() {
  let kpFirst = \[Int][0]
  let arr = [10, 20, 30]
  let first = arr[keyPath: kpFirst]  // $ MISSING: type=first:Int

  let kpKey = \[String: Int]["x"]
  let dict = ["x": 1, "y": 2]
  let val = dict[keyPath: kpKey]  // $ MISSING: type=val:Int?
}
