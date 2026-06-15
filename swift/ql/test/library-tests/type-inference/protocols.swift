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

// --- Protocol with associated types ---

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

// --- Multiple protocol conformance ---

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
