let shorthand = values.map { async in async.run() }
let multiple = values.map { async, value in async.run(value) }
let effects = values.map { value async throws in try await work(value) }
func collect() {
    self.any = any
    self.closed = closed
}
