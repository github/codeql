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
