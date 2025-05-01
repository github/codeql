func foo(_: Int, x y: inout Double) {}
func bar(_: Int, x y: inout Double) {}

struct S {
    subscript(x: Int, y: Int) -> Int? {
        get { nil }
        set {}
    }
}

func closures() {
  let x = {(s: inout String) -> String in s}
  let y = {(s: inout String) -> String in ""}
  let z : (Int) -> Int = { $0 + 1 }
}

@propertyWrapper struct Wrapper {
    var wrappedValue : Int = 42
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

func f2(
        @Wrapper p1: Int,
        @WrapperWithInit p2: Int,
        // @WrapperWithProjected p3: Int, // Disabled causes crashes with Swift 6.1
        // @WrapperWithProjectedAndInit p4: Int // Disabled causes crashes with Swift 6.1
) {}
