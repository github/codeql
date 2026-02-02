//codeql-extractor-options: -enable-experimental-move-only
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
let x = 42
let _ = _borrow x

struct UnsafeType {}

func unsafeFunc(_ y: UnsafeType) {
    @unsafe let x: UnsafeType = unsafe y
    let _ = unsafe x
}
