class A {
    var x: Int
    init() {
        self.self.x.self = (42)
    }
}

_ = (A())

func create() async -> A { return A() }
func process() async { _ = (await create())}

Task.init {
    await (process)()
}
