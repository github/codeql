@propertyWrapper struct Wrapper {
    var wrappedValue: Int {
        get {
            return 404
        }
    }

    init(wrappedValue: Int) {}
}

struct S {
  @Wrapper var x : Int = 42
}
