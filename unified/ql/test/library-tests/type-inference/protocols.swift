// --- Protocols and protocol conformance ---

protocol Shape {
  func area() -> Double
}

struct Circle: Shape {
  var radius: Double

  init(radius: Double) {
    self.radius = radius  // $ type=radius:Double field=Circle.radius
  }

  func area() -> Double {
    return 3.14159 * radius * radius  // $ type=radius:Double field=Circle.radius
  }
}

struct Rectangle: Shape {
  var width: Double
  var height: Double

  init(width: Double, height: Double) {
    self.width = width  // $ type=width:Double field=Rectangle.width
    self.height = height  // $ type=height:Double field=Rectangle.height
  }

  func area() -> Double {
    return width * height  // $ type=width:Double field=Rectangle.width field=Rectangle.height
  }
}

func testProtocol() {
  let c = Circle(radius: 5.0)  // $ type=c:Circle target=Circle.init
  let a1 = c.area()  // $ type=a1:Double target=Circle.area

  let r = Rectangle(width: 3.0, height: 4.0)  // $ type=r:Rectangle target=Rectangle.init
  let a2 = r.area()  // $ type=a2:Double target=Rectangle.area
}

// --- Protocol with associated types ---

protocol Container {
  associatedtype Item
  func getItem() -> Item
  func count() -> Int
}

struct IntContainer: Container {
  typealias Item = Int
  var items: [Int]

  init(items: [Int]) {
    self.items = items  // $ field=IntContainer.items
  }

  func getItem() -> Int {
    return items[0]  // $ field=IntContainer.items
  }

  func count() -> Int {
    return items.count  // $ field=IntContainer.items
  }
}

func testAssociatedTypes() {
  let ic = IntContainer(items: [1, 2, 3])  // $ type=ic:IntContainer target=IntContainer.init
  let item = ic.getItem()  // $ type=item:Int target=IntContainer.getItem
  let cnt = ic.count()  // $ type=cnt:Int target=IntContainer.count
}

// --- Multiple protocol conformance ---

protocol Printable {
  func display() -> String
}

protocol Identifiable {
  func id() -> Int
}

class Entity: Printable, Identifiable {
  var name: String
  var entityId: Int

  init(name: String, entityId: Int) {
    self.name = name  // $ type=name:String field=Entity.name
    self.entityId = entityId  // $ type=entityId:Int field=Entity.entityId
  }

  func display() -> String {
    return name  // $ type=name:String field=Entity.name
  }

  func id() -> Int {
    return entityId  // $ type=entityId:Int field=Entity.entityId
  }
}

func testMultipleProtocols() {
  let e = Entity(name: "test", entityId: 42)  // $ type=e:Entity target=Entity.init
  let d = e.display()  // $ type=d:String target=Entity.display
  let eid = e.id()  // $ type=eid:Int target=Entity.id
}
