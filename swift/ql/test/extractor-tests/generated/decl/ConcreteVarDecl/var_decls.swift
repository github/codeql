func loop() {
  for i in 1...5 {
  }
  var i = 0
}

var numbers = [42]

struct S {
static let numbers = [42, 404, 101]
}

@propertyWrapper
struct X<T> {
  var wrappedValue: T
}

@propertyWrapper
struct Y {
  var wrappedValue: Int
}

struct Wrapped {
    @X @Y var wrapped : Int
}

@propertyWrapper struct WrapperWithInit {
  var wrappedValue : Int

  init(wrappedValue: Int) { self.wrappedValue = wrappedValue }
}

@propertyWrapper struct WrapperWithProjected {
  var wrappedValue : Int = 42
  var projectedValue : Bool = false
}

@propertyWrapper struct WrapperWithProjectedAndInit {
  var wrappedValue : Int
  var projectedValue : Bool

  init(wrappedValue: Int) {
    self.wrappedValue = wrappedValue
    self.projectedValue = false
  }

  init(projectedValue: Bool) {
    self.wrappedValue = 0
    self.projectedValue = projectedValue
  }
}

func f3() {
  @X var w1 = 1
  @WrapperWithInit var w2 = 2
  @WrapperWithProjected var w3 = 3
  @WrapperWithProjectedAndInit var w4 = 4
}

enum E {
  case value(Int, Int)
}

switch E.value(42, 0) {
  case .value(let case_variable, 0):
    _ = case_variable
  case .value(0, let unused_case_variable):
    break
  default:
    break
}
