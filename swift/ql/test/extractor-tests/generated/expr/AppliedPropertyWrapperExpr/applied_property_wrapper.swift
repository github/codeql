@propertyWrapper struct Wrapper {
    var wrappedValue: Int {
        get { return 404 }
        set {}
    }
    var projectedValue: Bool = false

    init(wrappedValue: Int) {}
    init(projectedValue: Bool) {}
}

func foo(@Wrapper x: Int) {}

foo(x: 42)
foo($x: true)

let closure = {(@Wrapper y: Int) in return }

closure(41)
