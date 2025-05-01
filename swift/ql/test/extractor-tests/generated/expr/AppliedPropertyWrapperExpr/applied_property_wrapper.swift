@propertyWrapper struct Wrapper {
    var wrappedValue: Int {
        get { return 404 }
        set {}
    }
    var projectedValue: Bool = false

    init(wrappedValue: Int) {}
    init(projectedValue: Bool) {}
}

func foo(
    // @Wrapper x: Int // Disabled causes crashes with Swift 6.1
) {}

// foo(x: 42)
// foo($x: true)

let closure = {
    (
        // @Wrapper y: Int // Disabled causes crashes with Swift 6.1
    ) in return
    }

// closure(41)
