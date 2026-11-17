func sendingTask(_ body: sending @escaping () async throws -> sending Value) {}
func isolatedTask(_ body: @escaping @isolated(any) () -> Void) {}
let errorType = (any Error).self
let optionalError = (any Error)?.self
let middlewares = [any Middleware](repeating: passthrough, count: 5)
let dictionary = [String: any Device]()
let completed = { () -> (accepted: Bool, completions: [@MainActor (Policy) -> Void]) in
    (false, [])
}
let retained = (primary, repeat ManagedObject<each Secondary>.takeRetainedValue(pointer))
func optionalOpaque(_ x: some P?) -> any P? {}
func optionalSuppressed(_ x: borrowing any ~Copyable?) {}
func optionalMember(_ x: some P?.Q) {}
func opaqueComposition(_ x: some P & Q? & R) {}
