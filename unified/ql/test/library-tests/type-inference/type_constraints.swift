// --- where clause on generic function ---

func minOf<T: Comparable>(_ a: T, _ b: T) -> T {
  if a < b { return a } else { return b }
}

func maxOf<T>(_ a: T, _ b: T) -> T where T: Comparable {
  if a > b { return a } else { return b }
}

func testWhereClause() {
  let m1 = minOf(3, 7)  // $ type=m1:Int target=minOf
  let m2 = minOf("a", "z")  // $ type=m2:String target=minOf
  let m3 = maxOf(3, 7)  // $ type=m3:Int target=maxOf
  let m4 = maxOf("a", "z")  // $ type=m4:String target=maxOf
}

// --- Multiple constraints on a single type parameter ---

protocol Displayable2 {
  func display() -> String
}

protocol Sortable {
  func sortKey() -> Int
}

struct TaggedItem: Displayable2, Sortable, Equatable {
  var tag: String
  var priority: Int

  init(tag: String, priority: Int) {
    self.tag = tag  // $ type=tag:String field=TaggedItem.tag
    self.priority = priority  // $ type=priority:Int field=TaggedItem.priority
  }

  func display() -> String {
    return tag  // $ type=tag:String field=TaggedItem.tag
  }

  func sortKey() -> Int {
    return priority  // $ type=priority:Int field=TaggedItem.priority
  }
}

func showAndSort<T: Displayable2 & Sortable>(_ item: T) -> String {
  return item.display()  // $ MISSING: target=Displayable2.display
}

func showSortAndCompare<T>(_ a: T, _ b: T) -> Bool
where T: Displayable2, T: Sortable, T: Equatable {
  return a == b
}

func testMultipleConstraints() {
  let item = TaggedItem(tag: "x", priority: 1)  // $ target=TaggedItem.init
  let s = showAndSort(item)  // $ type=s:String target=showAndSort
  let eq = showSortAndCompare(item, item)  // $ type=eq:Bool target=showSortAndCompare
}

// --- Generic class with multiple constrained type parameters ---

class SortedPair<T: Comparable, U: Comparable> {
  var first: T
  var second: U

  init(first: T, second: U) {
    self.first = first  // $ type=first:T field=SortedPair.first
    self.second = second  // $ type=second:U field=SortedPair.second
  }

  func isFirstSmaller(than other: T) -> Bool {
    return first < other  // $ type=other:T field=SortedPair.first
  }

  func isSecondSmaller(than other: U) -> Bool {
    return second < other  // $ type=other:U field=SortedPair.second
  }
}

func testMultiConstrainedParams() {
  let sp = SortedPair(first: 3, second: "b")  // $ target=SortedPair.init
  let r1 = sp.isFirstSmaller(than: 5)  // $ type=r1:Bool target=SortedPair.isFirstSmaller
  let r2 = sp.isSecondSmaller(than: "z")  // $ type=r2:Bool target=SortedPair.isSecondSmaller
}

// --- Associated type constraints (same-type constraint) ---

protocol ElementContainer {
  associatedtype Element
  func first() -> Element
}

struct IntArray: ElementContainer {
  typealias Element = Int
  var items: [Int]

  init(items: [Int]) {
    self.items = items  // $ field=IntArray.items
  }

  func first() -> Int {
    return items[0]  // $ field=IntArray.items
  }
}

struct StringArray: ElementContainer {
  typealias Element = String
  var items: [String]

  init(items: [String]) {
    self.items = items  // $ field=StringArray.items
  }

  func first() -> String {
    return items[0]  // $ field=StringArray.items
  }
}

func extractFirst<C: ElementContainer>(from container: C) -> C.Element where C.Element == Int {  // name=extractFirst1
  return container.first()  // $ MISSING: target=ElementContainer.first
}

func extractFirst<C: ElementContainer>(from container: C) -> C.Element where C.Element == String {  // name=extractFirst2
  return container.first()  // $ MISSING: target=ElementContainer.first
}

func testSameTypeConstraint() {
  let ia = IntArray(items: [10, 20])  // $ target=IntArray.init
  let sa = StringArray(items: ["hi", "there"])  // $ target=StringArray.init
  let r1 = extractFirst(from: ia)  // $ target=extractFirst1 $ MISSING: type=r1:Int $ SPURIOUS: target=extractFirst2
  let r2 = extractFirst(from: sa)  // $ target=extractFirst2 $ MISSING: type=r2:String $ SPURIOUS: target=extractFirst1
}

// --- Superclass constraint on type parameter ---

class Vehicle {
  var speed: Int

  init(speed: Int) {
    self.speed = speed  // $ type=speed:Int field=Vehicle.speed
  }

  func describe() -> String {
    return "vehicle"
  }
}

class Car: Vehicle {
  override init(speed: Int) {
    super.init(speed: speed)  // $ target=Vehicle.init
  }

  override func describe() -> String {
    return "car"
  }

  func honk() -> String {
    return "beep"
  }
}

class Truck: Vehicle {
  override init(speed: Int) {
    super.init(speed: speed)  // $ target=Vehicle.init
  }

  override func describe() -> String {
    return "truck"
  }

  func haul() -> String {
    return "hauling"
  }
}

func describeVehicle<T: Vehicle>(_ v: T) -> String {
  return v.describe()  // $ MISSING: target=Vehicle.describe
}

func testSuperclassConstraint() {
  let car = Car(speed: 100)  // $ type=car:Car target=Car.init
  let truck = Truck(speed: 60)  // $ type=truck:Truck target=Truck.init
  let d1 = describeVehicle(car)  // $ type=d1:String target=describeVehicle
  let d2 = describeVehicle(truck)  // $ type=d2:String target=describeVehicle
  let h = car.honk()  // $ type=h:String target=Car.honk
  let hl = truck.haul()  // $ type=hl:String target=Truck.haul
}

// --- Constrained extension methods ---

protocol Summable {
  static func + (lhs: Self, rhs: Self) -> Self
}

extension Int: Summable {}
extension Double: Summable {}
extension String: Summable {}

struct Accumulator<T> {
  var values: [T]

  init(values: [T]) {
    self.values = values  // $ field=Accumulator.values
  }

  func count() -> Int {
    return values.count  // $ field=Accumulator.values
  }
}

extension Accumulator where T: Summable {
  func total() -> T {
    return values[0] + values[1]  // $ field=Accumulator.values $ MISSING: target=Summable.+
  }
}

extension Accumulator where T: Equatable {
  func contains(_ item: T) -> Bool {
    return values.contains(where: {  // $ field=Accumulator.values
      $0 == item  //  $ MISSING: target=Equatable.==
    })
  }
}

func testConstrainedExtensions() {
  let intAcc = Accumulator(values: [1, 2, 3])  // $ target=Accumulator.init
  let cnt = intAcc.count()  // $ type=cnt:Int target=Accumulator.count
  let tot = intAcc.total()  // $ target=Accumulator.total $ MISSING: type=tot:Int
  let has = intAcc.contains(2)  // $ type=has:Bool target=Accumulator.contains
}

// --- Generic method with its own constrained type parameter ---

class Transformer {
  init() {}

  func transform<T: Summable>(_ items: [T]) -> T {
    return items[0] + items[1]  // $ MISSING: target=Summable.+
  }

  func merge<A: Equatable, B: Equatable>(_ a: A, _ b: B) -> Bool {
    return true
  }
}

func testMethodTypeParams() {
  let t = Transformer()  // $ target=Transformer.init
  let r1 = t.transform([3, 1, 2])  // $ type=r1:Int target=Transformer.transform
  let r2 = t.transform(["c", "a", "b"])  // $ type=r2:String target=Transformer.transform
  let r3 = t.merge(1, "x")  // $ type=r3:Bool target=Transformer.merge
}

// --- Recursive constraint (Comparable requiring Equatable) ---

func clamp<T: Comparable>(_ value: T, min lower: T, max upper: T) -> T {
  if value < lower { return lower }
  if value > upper { return upper }
  return value
}

func testRecursiveConstraint() {
  let r1 = clamp(5, min: 0, max: 10)  // $ type=r1:Int target=clamp
  let r2 = clamp(3.5, min: 1.0, max: 2.0)  // $ type=r2:Double target=clamp
  let r3 = clamp("m", min: "a", max: "z")  // $ type=r3:String target=clamp
}
