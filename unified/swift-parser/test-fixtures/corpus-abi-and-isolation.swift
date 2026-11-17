@abi(nonisolated(nonsending) func checked<T>(_ body: (Continuation<T>) -> Void) async -> sending T)
func checked<T>(_ body: (Continuation<T>) -> Void) async -> sending T {}
typealias Handler = nonisolated(nonsending) () async -> Void
extension Model: nonisolated Protocol {}
let accessor = unsafeBitCast(raw, to: (@convention(thin) (Int) -> MetadataResponse).self)
