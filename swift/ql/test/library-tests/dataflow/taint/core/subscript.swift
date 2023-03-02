class SubscriptTest {
    subscript(index: Int) -> String {
        get { return "" }
        set(newValue) {}
    }
}

func source() -> Array<String> { return [""] }
func source2() -> SubscriptTest { return SubscriptTest() }
func sink(arg: String) {}

func test() {
    sink(arg: source()[0]) // $ tainted=13
    sink(arg: source2()[0]) // $ tainted=14
}
