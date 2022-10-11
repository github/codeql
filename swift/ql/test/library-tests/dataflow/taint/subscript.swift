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
    sink(source()[0]) // $ tainted=13
    sink(source2()[0]) // $ tainted=14
}
