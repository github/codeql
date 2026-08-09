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
