struct Foo {
  var x = 11
  var next : Int {
    get { return x + 1 }
    set(newValue) { x = newValue - 1 }
  }
}

class Bar { var x : Double = 1.3 }

enum EnumValues {
    case value1, value2
    case value3, value4, value5
}

enum EnumWithParams {
    case nodata1(Void)
    case intdata(Int)
    case tuple(Int, String, Double)
}

protocol MyProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
    func random() -> Double
}

func a_function(a_parameter : Int) {}

var a_variable = 42
var a_property : String {
  get {
    return "here"
  }
  set(newValue) {}
}

print("some top level statement")

class Baz {
  var field: Int
  init() {
    field = 10
  }

  deinit {
    field = 0
  }

  static prefix func +- (other: Baz) -> Baz {
    return other
  }
}

prefix operator +-

precedencegroup NewPrecedence {
  higherThan: AdditionPrecedence
  lowerThan: MultiplicationPrecedence
  associativity: none
  assignment: false
}

infix operator +++

infix operator ***: NewPrecedence

@propertyWrapper struct ZeroWrapper {
  var wrappedValue: Int {
    get {
      return 0
    }
  }
}

func foo() -> Int {
  @ZeroWrapper var x: Int
  return x
}

struct HasPropertyAndObserver {
  var settableField: Int {
    set { }
    get {
      return 0
    }
  }

  // A field can be marked as read-only by dirctly implementing
  // the getter between the braces.
  var readOnlyField1: Int {
    return 0
  }

  // Or by adding an access declaration
  var readOnlyField2: Int {
    get {
      return 0
    }
  }

  var normalField : Int

  subscript(x: Int) -> Int {
    get {
      return 0
    }
    set { }
  }

  subscript(x: Int, y : Int) -> Int {
    return 0
  }

  var hasWillSet1 : Int {
    willSet(newValue) { }
  }

  var hasWillSet2 : Int {
    willSet { }
  }

  var hasDidSet1 : Int {
    didSet(oldValue) { }
  }

  var hasDidSet2 : Int {
    didSet { }
  }

  var hasBoth : Int {
    willSet { }

    didSet { }
  }
}

extension Int {
  func id() -> Int {
    return self
  }
}

42.id()

class GenericClass<A, B: Baz, C: MyProtocol> {
  func genericMethod(_: A, _: B, _: C) {}
}

func genericFunc<A, B: Baz, C: MyProtocol>(_: A, _: B, _: C) {}

class Derived : Baz {}

// multiple conversions
var d: Baz? = Derived() as Baz

func ifConfig() {
  #if FOO
  1
  2
  3
  #else
  4
  5
  6
  #endif

  #if BAR
  7
  8
  #endif

  #if true
  9
  10
  #else
  11
  12
  #endif
}

class B {}
typealias A = B
typealias C = Int?

class S {
  var bf1 = 0
  func captureThis() {
    var x = 0
    var f = { [self, x] () in
      self.bf1 = x
    };
  }
}
