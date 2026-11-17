func benchmark() {
    yield()
    yield(value)
    yield.handler()
}
struct Coroutine {
    var value: Int { _read { yield storage } }
    consuming func done() {
        return
        discard self
    }
}
