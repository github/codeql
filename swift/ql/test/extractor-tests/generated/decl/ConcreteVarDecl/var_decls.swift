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
